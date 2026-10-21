class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "990390ca12d8546223e340fc78bb5177328e6b259c3cc9ca205aedeaa57b4209"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42883975af64fc458a3b3ed5633207809893e67062574b089ccaeca54e9c195b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "214dcde38c1ba47c14868aba942e1b77d49f53facb7187fbff5f7cb94db0211d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22c320105b1e394b56305d494a7a3e0793038f21518e7f876f8eb7ee8ed2e294"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "886207f496d5dbde00637a022c6874903cbfe7f71832bff89de17ab28830b780"
    sha256 cellar: :any,                 x86_64_linux:      "ef6783b0302bff6911319ef098932459b68dcd4505f4dfe747f4139c90bee604"
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
