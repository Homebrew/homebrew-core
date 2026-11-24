class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "5a1ba8f72ccefc0ccb03a0a19db1f9e9c20c9374f848d14d73035f45e5258c86"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    manifest_sha256 "552aae4c22e69879cc5f57e08f1f3819a631768f2a1d6100ca0969c0966aacbd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b03900d2c4e0ad4b79bd79c0078f41093b4e972ef103e08586fd15a2442dbe0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21b2ae7dc46c22a9bd4a29fd25f57416f336642481b94aff7d7fba85327f27c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9d2efe58776c09413540f6850217207b2244a8588e88dd8771f643bf3ca4432"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3aef0ffe992f880fb59017de8c7e20044d1c02d7d56aafce96f071e6ee64452"
    sha256 cellar: :any,                 x86_64_linux:      "3835af41670d736495fe29e99fa82a8efa1d37d8a8fe61690761793b5f3bdd23"
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
