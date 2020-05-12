class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.10.0",
      :revision => "f318680e7e5bf539f7fadeaaf198f4e468393fb9"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92745dcc63ef063dfc1723358df84436898799e6f97e2a4c8559c9ae3cbf63d6" => :catalina
    sha256 "700c988a623e1ee42075dd4c328f1f71cb9cdc08b62b313de124101ec3e8069c" => :mojave
    sha256 "b5583885515bbf5de6cc70b0365cd01ad79441041e88e473470f2de6bc4b9f5c" => :high_sierra
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
