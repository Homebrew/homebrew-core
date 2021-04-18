class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.20.0",
      revision: "c61663e942ec43b20e8e70839dcca52e44cd85ae"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53cc2891ce5c064248d527505b6bd52609cec749f5276db3a85f3446545c6f36"
    sha256 cellar: :any_skip_relocation, big_sur:       "22ed1a5612a4adea9fd5498dd5ee7239b91b25b76f0b0f3ec0dae526c262f760"
    sha256 cellar: :any_skip_relocation, catalina:      "516c090d58dd73861792aebcebcf1944fdea269c8272d10c8899ce0ba56de8e3"
    sha256 cellar: :any_skip_relocation, mojave:        "b657f734e8feb8dd5437f653c06f4c975209533ef39bb0cf4fe4a00cba08357b"
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

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
    (fish_completion/"minikube.fish").write output
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
