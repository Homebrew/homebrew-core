class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.7.3",
      :revision => "436667c819c324e35d7e839f8116b968a2d0a3ff"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbba21e83cbdc7b4827ec790fbcfb35138e3f71258ffe84d5ca32862ee469623" => :catalina
    sha256 "9a8d465faacc19e8183fcdc3702c9b2a2f8944b83fbc781cfd2212966c25eb85" => :mojave
    sha256 "31840d2aa66a48d16d296229212961d344ce28252d310cc0ad0572fd0aec5571" => :high_sierra
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
