class Minikube < Formula
  desc "Run Kubernetes locally"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube/releases/download/v0.17.1/minikube-darwin-amd64"
  version "v0.17.1"
  sha256 "b175c355d377a6ce2fefdd19201c865a7e628581261ac949fffb725af459c389"

  def install
    mv "minikube-darwin-amd64", "minikube"
    bin.install "minikube"
  end

  test do
    system "minikube"
  end
end
