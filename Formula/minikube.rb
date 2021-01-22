class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.17.0",
      revision: "7e8b5a89575945ba8f8246bfe547178c1a995198"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b6d7d1b97b11b6b07e4fa531c2dc21770da290da9b2816f360fd923e00c85fc" => :big_sur
    sha256 "232e37266350ad00be5b3f360564f8e4ebe0c5e4da9bf45e855a2a7fc9b5f1eb" => :catalina
    sha256 "28f42d08bb00ffc800b381b6f6b80d5b20f5b2bfd90e62dd84585c18da87e693" => :mojave
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
