class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "431f0fae6c58dc98c8a5e8e2e5b6c4b8cecfa3308f5ec3669e36fe927c50238c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ca678b0a62d537c6a9faaae227024c2d6f18bef2b554fd6d6d08efbbfba32a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fcfd23ba3319f03f19c57d76bea4dfef60fd28c9996cb6486c5911faed8c198"
    sha256 cellar: :any_skip_relocation, monterey:       "eb2c77a08fa2e8773d87e685400fad0e216b66803525e459256c68d48f3ab2f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "931d46f448a4db364f579a45130c2f1b41a0b49a78ffd05c745d211b4e7af671"
    sha256 cellar: :any_skip_relocation, catalina:       "ae621c4c06719a7c51f1cc53d13bde19f7a49263a23eaf5bedb8b2a65f4bac3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04cc8580d4e41c0d424149ae53ac9cf3e5e88e45fb1fb0a8c3e391e78dccced1"
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
