class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "c6cf10b9d24936b4ff6fe1fa68c0a086d0e3589142e93d59149c5c6b6a21472c"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "149f34ef498142a1bb2976cd21d840aaada2ec05dfc9cdc519fa221cd066f6ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c83454e80b0716f2e1ac884b4ad8047742deb47379da510bad76d80e9c2a44f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8975ff886a4022767f303ad781b0408dd558cc69cedddc5e8570544ba6c48338"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e282c87eb768a71da44d7946c658395c79d00c243672d743ab2e6104045d53ba"
    sha256 cellar: :any,                 x86_64_linux:      "eb6267b8988325e7a50f9aa50ed115c3528324e37c2a23f6ddc853080ad500af"
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
