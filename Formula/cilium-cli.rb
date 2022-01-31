class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "431f0fae6c58dc98c8a5e8e2e5b6c4b8cecfa3308f5ec3669e36fe927c50238c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619e2e2b7967fdc6988ce71bd44185bed20e6c4b6726b0761d2ee08758d6d2e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5af273f77f1bbdbd062ef1764379b35a02aea9d1cce6887bba3e0fddf494ae05"
    sha256 cellar: :any_skip_relocation, monterey:       "e36b1c6e6c139ba4e402b1c9fedb819550ec83c1dbbea6eca81c37927364227f"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ae9e9a195d8e3904c6fcd44fa5cfe281ff5cc084ce32fbf7c33b699d3f5239"
    sha256 cellar: :any_skip_relocation, catalina:       "1bcb84c353d8d4b58dd4af9c321dc1dd5d08b7372251c63125a53276b0fe1c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b225c8182797972d5830fb40d0789ef07f731a3cacecfb8e441645378f2d8ca1"
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
