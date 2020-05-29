class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.11.0",
      :revision => "57e2f55f47effe9ce396cea42a1e0eb4f611ebbd"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0ba6e4c2d00def3af2aa2db3535aef37bb3a7bfe182f35277b3a510b0edffeb" => :catalina
    sha256 "6e08ab38dae682a44309b01b80e7692de16cac4724dba06244479d4c63c6ee16" => :mojave
    sha256 "32dc82f2cc59379aa9a8842438fc34a90abfa1df2b6a70311e94dd11ff4bcba4" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.popen_read("#{bin}/minikube completion bash")
    (bash_completion/"minikube").write output

    output = Utils.popen_read("#{bin}/minikube completion zsh")
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
