CREATE DATABASE churn_analysis;
USE churn_analysis;
# CREATE TABLE
CREATE TABLE customer_churn (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(10)
);

# NULL VALUE HANDLING
SELECT *
FROM customer_churn
WHERE TotalCharges IS NULL;
SET SQL_SAFE_UPDATES = 0;
UPDATE customer_churn
SET TotalCharges = 0
WHERE TotalCharges IS NULL;

SELECT *
FROM customer_churn
WHERE TotalCharges IS NULL;

# DUPLICATE CHECK

SELECT customerID, COUNT(*)
FROM customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

# CHURN RATE
SELECT 
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn;

# WHICH CONTRACT HAS HIGHEST CHURN?
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY Contract
ORDER BY churned_customers DESC;

# REVENUE LOSS
SELECT 
    SUM(TotalCharges) AS revenue_lost
FROM customer_churn
WHERE Churn='Yes';

# ADVANCED SQL — CTE
WITH churn_cte AS (
    SELECT 
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churn_customers
    FROM customer_churn
    GROUP BY Contract
)

SELECT *,
       ROUND(churn_customers*100.0/total_customers,2) AS churn_rate
FROM churn_cte;

# WINDOW FUNCTION
SELECT 
    customerID,
    MonthlyCharges,
    RANK() OVER(ORDER BY MonthlyCharges DESC) AS revenue_rank
FROM customer_churn;

