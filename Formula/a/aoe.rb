class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "464b3c62d2a5627275bdcd4dfd7983b0a0a11a5f966126b6b0b49fdd780e67f1"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55c8c5fabfc7252759a9bf7b67b75ee64780be5501257914f20853378a128efb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0007d5f7c1cfad1ea4312f9225f4a48513499fdc8ffb78a155ff08c87f3b0d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e881e38a6a2f609a09ade03408308ae72aa969a6c4b94bfa7e5c0e1371f08db9"
    sha256 cellar: :any,                 arm64_linux:       "e80a8cd908de182717e73119f0eb74712da4cd822996d8ea2a41a5845f9b586f"
    sha256 cellar: :any,                 x86_64_linux:      "c98ae697576f7cf813cffe11e6d1f2f14fd63466946b69cb78dbbd0effe64fc4"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
