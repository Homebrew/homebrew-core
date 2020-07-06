class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.11.0",
      :revision => "57e2f55f47effe9ce396cea42a1e0eb4f611ebbd"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b1725719ff2a2973f20e5583021584302bb29d9dd23448709e016a19c101ba4f" => :catalina
    sha256 "6d825680b695c127d29ad63a50ad3d8dd1c129d35fa90ce623f878eb7fe7dd32" => :mojave
    sha256 "7ff75886b7fb884af278652c63e715afadeb940e1a66d491637a59aa95980165" => :high_sierra
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
