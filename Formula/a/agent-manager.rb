class AgentManager < Formula
  desc "Terminal UI to manage AI coding-agent tmux sessions"
  homepage "https://github.com/YoanWai/agent-manager"
  url "https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "e219d26e331a5e8483b7665d08bc140198d5bfc587b610c8caa05f1f872d6657"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildSource=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-manager --version")

    requests = [
      '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}',
      '{"jsonrpc":"2.0","method":"notifications/initialized"}',
      '{"jsonrpc":"2.0","id":2,"method":"tools/list"}',
    ]
    mcp_output = ""
    IO.popen("#{bin}/agent-manager mcp", "r+") do |pipe|
      pipe.puts requests.join("\n")
      2.times { mcp_output += pipe.gets }
    end
    assert_match "\"serverInfo\":{\"name\":\"agent-manager\",\"version\":\"#{version}\"}", mcp_output
    assert_match "\"name\":\"create_terminal\"", mcp_output

    require "io/console"
    require "pty"
    ENV["TERM"] = "xterm"
    ansi = /\e\[[0-9;?]*[a-zA-Z]/
    screen = ""
    wait_for = lambda do |reader, needle|
      deadline = Time.now + 30
      until Time.now > deadline || screen.gsub(ansi, "").include?(needle)
        begin
          screen += reader.read_nonblock(4096)
        rescue IO::WaitReadable
          sleep 0.2
        rescue EOFError, Errno::EIO
          break
        end
      end
      assert_match needle, screen.gsub(ansi, "")
    end
    PTY.spawn(bin/"agent-manager") do |reader, writer, pid|
      reader.winsize = [43, 120]
      wait_for.call(reader, "Welcome to agent-manager")
      writer.write "\e"
      wait_for.call(reader, "A G E N T   M A N A G E R")
      Process.kill("TERM", pid)
    end
  end
end
