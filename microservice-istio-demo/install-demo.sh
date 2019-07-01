#!/usr/bin/env bash

echo "Configure docker env"
eval $(minikube docker-env)
# install istio

echo "enable istio injection"
kubectl label namespace default istio-injection=enabled

docker build --tag=microservice-istio-apache apache
docker build --tag=microservice-istio-postgres postgres

mvn clean package -DskipTests jib:dockerBuild

echo "Setting up infrastructure..."
kubectl apply -f infrastructure.yaml
kubectl apply -f logging.yaml
echo

echo "Setting up logging..."

echo

echo "Deploying Services..."
kubectl apply -f microservices.yaml
echo
