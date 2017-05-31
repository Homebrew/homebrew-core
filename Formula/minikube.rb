class Minikube < Formula
  desc "Tool that provisions and manages local single-node Kubernetes clusters"
  homepage "https://github.com/kubernetes/minikube"
  url "https://storage.googleapis.com/minikube/releases/v0.3.0/minikube-darwin-amd64"
  version "0.3.0"
  sha256 "cada05315d6643a3d8813b75c36b703773df739f32a576b25b8572a51ca90ee6"
  head "https://github.com/kubernetes/minikube.git"

  def install
    mv "minikube-darwin-amd64", "minikube"
    bin.install "minikube"
  end

  test do
    assert_match /^minikube version: v0.3.0/, shell_output("#{bin}/minikube version 2>&1", 0)
  end
end
