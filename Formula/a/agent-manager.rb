class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "e950c16d59a6c58d2daa52561f6a7017d66236b3946ee861b47eecab37b6feff"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "670c571ca1375a103984a3098920340f3159c07720f28ad17a68acd3edc0edec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bddd318c10a8b0cd87f9a7f45d7258c6aae6c0b3389dc743217b3fced4aa951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a7b3b2c08a8c9cbe49a47eee4909dd03f17fbb0e0608420db1b1d5a4914e224"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed796156b816cc19c939c6487016652635925422df2248e5d8ef2ac160dae2d2"
    sha256 cellar: :any,                 x86_64_linux:      "867b9676c40301aaf79660ea63ade2dc462cf23cda2aec738beceada8bc79536"
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
