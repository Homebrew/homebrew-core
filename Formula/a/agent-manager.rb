class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "b6062287875f568f45603295725abe1b450330a814523fd44fcf1978c68ee606"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95922bd3eca28d5e32b3e531f907c11a8a5fcf903bb9f736e849c66bd5f48f7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22f40ca20c617352b3559be7599063bb17f12ff5efe412bf5205b9797f3001c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a89a5cea3f324c9a3432926b7b7d63003cbe44dd882d804eb1af7941d36a4c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c77c4d059cb49ea93d9977a760fd5b00661badab9ab697f3e0012cfe987cdd8"
    sha256 cellar: :any,                 x86_64_linux:      "064618c9552e0a629f7edcd33f04f6b4f7604e8e0315f0a9ba4a395202d47895"
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
