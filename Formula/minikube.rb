class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.17.1",
      revision: "043bdca07e54ab6e4fc0457e3064048f34133d7e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "645cc05655411bddc944818278eca867049e7e2712411dd79028f404ed83d08a"
    sha256 cellar: :any_skip_relocation, catalina: "4d5263bf35d8800cec7c820f6efcb32fac1677627f21954888b97daedbeeb7a1"
    sha256 cellar: :any_skip_relocation, mojave:   "0edb5f37a1d108806f20966b02a0cb805e69f285a8b00ece64f1e0dad42449e6"
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
