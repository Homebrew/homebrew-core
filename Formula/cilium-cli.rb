class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "7f1f2e6d58ccee2d2b2bb16af1bf2daf861b74a383596a1c38aded28dec0c08a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a1b40ed1aeb39a90c1f14d3f9b6ed1a63c86663308d93c67dd324349af8526f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25ca71c3c7018a6aef18de32544e8ff37f5b816dbaf2a7fcfaa03d91e4d8435c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7270d7ee90d2e55dd30367814bd215cd12b094dc3d16134002047f0646f1bcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1869094cf7a7a6e4f5227a6f624f69692f5c0884e093e531b14e7ccc6198b360"
    sha256 cellar: :any_skip_relocation, catalina:       "92474fd1f76b68a24f3ff6948743b21c885587084894d5403ab98a4eb34b77a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef98096ab40aef7404e5ea904b86d8c250814b61f97a4361ee2d8b6e901b125"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
