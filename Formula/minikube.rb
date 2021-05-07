class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.20.0",
      revision: "c61663e942ec43b20e8e70839dcca52e44cd85ae"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8704e50e9352938720b0e17b685c7958f69dbd52b3077df8babb2d3bc64e66b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f8af400d4277ccc4a6f2c09b69995ba6f4a8fd5c11295c16201b5171232bf20"
    sha256 cellar: :any_skip_relocation, catalina:      "b4873d9893a068b12f6c4b8c2e728e6617f9f6c6f2b957bd9b117a3a57f4d8cf"
    sha256 cellar: :any_skip_relocation, mojave:        "d742d09ccb67f4643d26f54442a0560d5858d40b3fc960d2e6daa242a0cf5a25"
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
