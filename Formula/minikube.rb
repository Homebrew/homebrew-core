class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.14.2",
      revision: "2c82918e2347188e21c4e44c8056fc80408bce10"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d611a2f29bcdad6c59656df2304c699ae4f3c3827e953468233dc8972d5e962c" => :catalina
    sha256 "93f000abb4782e0fdf68b9463e401a9cfbb3f3d77b8336b8b8041b92039b2a8e" => :mojave
    sha256 "e02308e18926d74c36eabfc5d56c505165e2cec6e9e32af298389b8a172e40e8" => :high_sierra
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
