class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.23.2",
      revision: "0a0ad764652082477c00d51d2475284b5d39ceed"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "411ea18df0188d18082243d7e1d8c8580b99b9b3863b11054298ea22d8a18eaf"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f40fec3397dbd2bb39d75f5296fb74fb15128f2db5e0cdb3b6fdf5270bcbb06"
    sha256 cellar: :any_skip_relocation, catalina:      "5196ffa5f072726997f3d9f08bd6dca691ac9ae9006901112e239da420f0f6fa"
    sha256 cellar: :any_skip_relocation, mojave:        "9e9f1212e1bb99a532a0697f81d6ff4b85d2a3e50962376fe3efac4dd6f48c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d407a3084338100f6eb0a483bad3bc9e8c2bbeb6d1ec473a168a4edffca249e"
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
