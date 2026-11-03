class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "6f33282969789381390ed74221e00c731a69dda7e9c4dc057fccea609443c209"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40c8f159577d51e6e27731996f81d88bd329797e9d4bd4f11f4144646ddb4605"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "596a1a9bdbca27abcc0cbc93252fc5677294febaa8769bac501c2d8b471afa81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2de4ba21bc0a8f49e709eec63e6daad12ff6ccc9222fd4e0723edfb1ff2697b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a431bdf20458e0bd36ff714795a0c8659347a145c6cd6702b8038b48ee2ced4"
    sha256 cellar: :any,                 x86_64_linux:      "4f85c038792cfe7c9cd1c4b86e65c8626308ae780dd63c60baa484427531f5b1"
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
