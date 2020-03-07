class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.8.1",
      :revision => "cbda04cf6bbe65e987ae52bb393c10099ab62014"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "628f65b54b7ef018436d152087b835d24868405c2e13dab0d663e228ae6b054b" => :catalina
    sha256 "235ed3078e1cf76727d25ed7f8d50cb0bf1ae12971e5bad72200575b3fa90711" => :mojave
    sha256 "b66d4fd5b11c2e3d8513aefeb4f759a14c285d9b797ba5f8f259645ba55a9a7b" => :high_sierra
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
