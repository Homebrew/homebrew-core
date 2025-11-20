class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://github.com/Sesame2/gotun/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d63768ad7ae61b2fa29f100e22af19b9d43886eb85712e64c58d24b9408b92c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "700956caa0621363c75435dcb00f638b26ac709be5b41cc850561b05c99bc94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700956caa0621363c75435dcb00f638b26ac709be5b41cc850561b05c99bc94b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700956caa0621363c75435dcb00f638b26ac709be5b41cc850561b05c99bc94b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9359d4ea158a6c165a1f02c694cde47e5155234933c2136500fb5433027b562b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d25f8a2fc8013990e210a4654bd55d91fb53135133a300c6f778235434ed6037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89af90bec14e9b584e6e2fb1751f11809f72ad43d570c6ef56ff69c79b52d94"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotun"
    generate_completions_from_executable(bin/"gotun", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotun --version")

    port = free_port
    server = TCPServer.new(port)
    server_pid = fork do
      msg = server.accept.gets
      server.close
      assert_match "SSH", msg
    end

    require "pty"
    r, _, pid = PTY.spawn bin/"gotun", "anonymous@localhost", "-p", port.to_s, "--timeout", "1s"
    sleep 1
    Process.kill "TERM", pid

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "HTTP-over-SSH", output
    assert_match "localhost:#{port}", output
  ensure
    Process.kill "TERM", server_pid
    Process.wait server_pid
    Process.wait pid
  end
end
