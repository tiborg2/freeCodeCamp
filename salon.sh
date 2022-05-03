#!/bin/bash



PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "$1"
  else
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi

  #Main service menu
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo  "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  #Service Selection
  read SERVICE_ID_SELECTED

  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  #Iservice doesn't exist
  if [[ -z $SELECTED_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  #Getting customer phone
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #Selecting customer
    CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    #If customer doesn't exist
    if [[ -z $CUSTOMER ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      echo -e "What time would you like your$SELECTED_SERVICE, $CUSTOMER_NAME."
      read SERVICE_TIME
      echo -e "\nI have put you down for a$SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    else
      CUSTOMER_NAME = $CUSTOMER
      echo -e "What time would you like your$SELECTED_SERVICE, $CUSTOMER_NAME."
      read SERVICE_TIME
      echo -e "\nI have put you down for a$SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}
MAIN_MENU
