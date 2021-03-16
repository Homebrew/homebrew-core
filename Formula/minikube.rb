class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.18.1",
      revision: "09ee84d530de4a92f00f1c5dbc34cead092b95bc"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "714a97e881e2daa8082569743a53a715f40634809f352c0cb8639182aa79b54c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6b1490bdfbf8f3dde31f8bdc3f8222b7ab11dc3842682c2770a5ba5aa5cfbfe"
    sha256 cellar: :any_skip_relocation, catalina:      "ca09a0fb9854641e6352fc1a983529f21bcac35be52b39d0cf664033459af893"
    sha256 cellar: :any_skip_relocation, mojave:        "12a604af770bc1d6cf2fafc709009b1f7b8bc791b04df68e05d09ee54be13aa1"
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
