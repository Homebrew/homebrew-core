class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "c6cf10b9d24936b4ff6fe1fa68c0a086d0e3589142e93d59149c5c6b6a21472c"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5787c082a1468cca2fa918b75a5151f52fe83894b855e3db31c539a749554aff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b90d638a0229b66bb26bcb0632c4836b49bce3e6325737de34c8c119f681c53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4efcd2cdae1ae5023679cd761ceb7b6a55f920aab8318e2370dea8f87db5ab8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f222654c30fcc709fce2c15e04478216cd4035f5ea21b8ba8d1adfb177e17c20"
    sha256 cellar: :any,                 x86_64_linux:      "33e976aa267066a80ca16bd529f82bf5785de14d5e77b9a5b13bb21efee508dd"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildSource=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-manager --version")

    IO.popen("#{bin}/agent-manager mcp", "r+") do |mcp|
      mcp.puts '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}'
      assert_match "\"name\":\"agent-manager\",\"version\":\"#{version}\"", mcp.gets
      mcp.puts '{"jsonrpc":"2.0","method":"notifications/initialized"}'
      mcp.puts '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
      assert_match "\"name\":\"create_terminal\"", mcp.gets
    end

    require "expect"
    require "io/console"
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"agent-manager") do |r, _w, pid|
      r.winsize = [40, 120]
      refute_nil r.expect("Welcome to agent-manager", 30), "the TUI never rendered its welcome message"
      Process.kill("TERM", pid)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
