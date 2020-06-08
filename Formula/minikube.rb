class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.11.0",
      :revision => "57e2f55f47effe9ce396cea42a1e0eb4f611ebbd"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "458c030e48c868ac3499c8d321656c67ac4b10637d1549f9e2921c5eab4d0963" => :catalina
    sha256 "79f7f401711c9c3c2519c93c5b0bb22e7491c4a2b44b06ed8e6a362b25885cd5" => :mojave
    sha256 "b68b609f8165cccd4f418a5a2f4dff9baa1ed13fb16b98f1d6dcf121c6d4495e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube completion bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube completion zsh")
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
