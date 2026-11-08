class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "e950c16d59a6c58d2daa52561f6a7017d66236b3946ee861b47eecab37b6feff"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84c45fe8aa91e0706040a4a3b4faa6fc2032db4a69c066da454f7a0e11661c9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d33d623ffaaa95d8bfecc6c745079e0b5b9e81e25718e2726df0442cb8f790c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42bf293d3c8e74fcc15da97f0fc774996db1ba50ad2a560181ca53766f3e1dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f2719fe2924235ec317761c4f10f1eccddab963d2a126aeed0928fb73f978ef"
    sha256 cellar: :any,                 x86_64_linux:      "2bd66aa40e614fd3264bd67f7edade2ce3156f50876fb299d912a6f7d88b8548"
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
