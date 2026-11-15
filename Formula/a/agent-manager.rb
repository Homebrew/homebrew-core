class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "47fe35e9e3b5455a1e28947b3a4359ba62716024fc89057045fce9bf469bd8e1"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f04e90b1d455cee92d1ee5761d54b6acd6d992b817a97c6b098dcd84c21ff0ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a402a4564648812990d18e274179d0843d0073a250e7002924bf36d8a279df8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8765025f0d836d6980d53eaa1e901462423526e747f0a2f1668fd99f1fe12375"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5ca035ac284cde759982fb79ede22aeeb307c50c954ef4a24c078ff5e772aa9"
    sha256 cellar: :any,                 x86_64_linux:      "cf51cb722352eb764c61aef1e7f95b8dc81942bb9979d4cd9c495cc9e4250c04"
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
