class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "cdf109969f5503d0d217da62836b0619afb72e0ba2896c10f1d0c455645c8b20"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "719ecc2044efcfb66600fa0d41f72bd535b59771c8fe56b02d176eeb11910542"
    sha256 cellar: :any,                 arm64_sequoia: "b66f92a4ad5f6078d68597a2d5a0124afcd83a559203944390345323686d9954"
    sha256 cellar: :any,                 arm64_sonoma:  "9f7ec565829ba4a712ff67efc08e19a9b50c02e57e0a1c23e6cf23ca7472a2b9"
    sha256 cellar: :any,                 sonoma:        "3c112be9845abe179b7fd9709e8d3d37afb1cb4030f0450a5a48e43e73fe47ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3773469d543acfc27e2e5dd0be688069c935f3bd82d0c8cc3c23fb499cbc5e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff60ae17359bfd75e58c82dc348e5212d5c62b98f8e04b1010d341c9576d05a9"
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
