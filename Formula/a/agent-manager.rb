class AgentManager < Formula
  desc "Terminal UI to manage AI coding-agent tmux sessions"
  homepage "https://github.com/YoanWai/agent-manager"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "55b74bfac8507542ed7c6d9d79ee1ca52bb3f7e9eec8ba40cf0cb332e532fb64"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ce0a5981f0b3e508268c02a2bf715804434bbfbc0dcc5a07fe7832d1222537b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f7ee2d9eee041b36fce8ddb34b099a9853aae5f47eff5a7262810a8b3b628dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c980654934d9a3d3e79e1e2323ad371f070f9743d209cb4309d322505896ca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5972375df8f365bfd6662c64b7bb944a413a6589a703ce65f5f96f57571e9e7"
    sha256 cellar: :any,                 x86_64_linux:      "d6634a31f8c4aaecafa00b3534d830ac3af4b831ac8871a7a6cacc8bd96def83"
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
