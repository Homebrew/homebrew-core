class Minikube < Formula
  desc "Run Kubernetes locally"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube.git",
      :tag => "v0.26.1",
      :revision => "6ded2b647d1b1f62100c630bcfcc1363c631ce2d"
  head "https://github.com/kubernetes/minikube.git"

  depends_on "icu4c"
  depends_on "kubernetes-cli" => :optional

  def install
    bin.install "out/minikube"
  end
end
