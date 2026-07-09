class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "033ec2d249ef8b743b933a92120a0540f512810fd1b4c52948a2aee5b124409e"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d82e1f8c645d6ffa6b717ad05168bf97c98668f4867f5d593f15b7fea7782d4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c913cb164194c2b7bb77a61fca0cc2440aa4102d176eb1938b53f0620945701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516c5ad50acd776ea86d02ab3245351c80895ed69ee5a31168cf2ab729214969"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e9556340b979541a7b5f7e371c8a22e9e69c7734b901ba869851c13ac016155"
    sha256 cellar: :any,                 arm64_linux:   "0ea75d1269770f098d8ed5027ee84cd9575045fba202442f2d8e37af6376b9f1"
    sha256 cellar: :any,                 x86_64_linux:  "7df1be0badcc614904ba101a9ad23a0bfd352c6a7fd2fd1511744522ba893933"
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
