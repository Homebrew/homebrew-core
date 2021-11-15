class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.24.0",
      revision: "76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3672e4faa44598b7a4015607c05861969461a9831f3ddfd894b4731896c69e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e61a9f3d86b74b4d1248fed2b9a2f3901dda0feccab714567e93f0f29717a843"
    sha256 cellar: :any_skip_relocation, monterey:       "0385fcb25a2009995119471d968d4c04925ffb29413ad07e87d94bc99af1d620"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6c111d5a6a004c5580b729dfe9daa342f3f04e4cf3831b5d65d29d4fb74a10e"
    sha256 cellar: :any_skip_relocation, catalina:       "da0ac07ef5f0d4770e1af0ead7e0ebc0b5e23c249ec86c407475a22c93b87ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe6ec45fbae6dae4ce39fbba988673c72bc5bb5bfaa8933ad666ee209e08be9"
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
