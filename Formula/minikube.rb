class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.25.2",
      revision: "362d5fdc0a3dbee389b3d3f1034e8023e72bd3a7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dee5f22e08636346258f4a6daa646e9102e384ceb63f33981745d471f99aa97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eb8da6b2e82a10729008118534956b8f52427a130aeb8f48a8f86409c498070"
    sha256 cellar: :any_skip_relocation, monterey:       "888a850d809aa5c62c3e3ccb40b059faf52a4519881f08bf93ec1267558b622e"
    sha256 cellar: :any_skip_relocation, big_sur:        "61c39cf9518c3589039934da686210f3790c3644a872926f38dfd291c857f494"
    sha256 cellar: :any_skip_relocation, catalina:       "7d59e9765d4d5359d71e3e2c5c359897502637d8864d2359bba1949bdd976521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01859de13052b91dbe5f12e3fd47fbd542e0ab6560c038e5f79e3df74098716b"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read(bin/"minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "fish")
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
