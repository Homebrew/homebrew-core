class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.21.0",
      revision: "76d74191d82c47883dc7e1319ef7cebd3e00ee11"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "771f87cd33cea144340252f06615b4d7fbbe2a24cf8650422f92980dc750ed52"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee8a9463cfba15edeb279dad222091c22999b0163456c949a00739aac7ac24ff"
    sha256 cellar: :any_skip_relocation, catalina:      "32ff0622ea10902be0d68057e3d4a61e7cff7eecdd0e3a3a61fb48a4637c635c"
    sha256 cellar: :any_skip_relocation, mojave:        "0cdc4efab315f963cf7957626597025c0599caf300831ce32d32d03dcc3fe4fd"
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
