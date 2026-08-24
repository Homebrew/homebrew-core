class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "9801e1efc3348e9d3e84e4ec23e7de5a0e154e2f2cd325f46f4d6766c8e9d9f6"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ae620bb18a7d6f416f367eea220adcd9ef87c32ffd4f1d34e3501e82094388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1399ae2f90574d78734076f77e13a50f9cc9b067fc3af496ea628f712ad733c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d799097f06c4b8058029354a00512709200336e83ccf881c2b945392cffaee"
    sha256 cellar: :any_skip_relocation, sonoma:        "20372c454e9f2627106b3fc3f531068a34e9fa8ffdc4eaf195e6e6bdc984307d"
    sha256 cellar: :any,                 arm64_linux:   "4c5ddf8a5268dea708e3c3936a5fa802d3c611c121e02f740a3c0292facceff0"
    sha256 cellar: :any,                 x86_64_linux:  "ddad7134341479d3ec391f515cab45f88fc752e3b2c91b5c1957aaaf5548151d"
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
