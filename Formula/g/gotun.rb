class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://github.com/Sesame2/gotun/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c0521f2e4df9bd8bae9afbca4bd4ab48bc1b3b24ef06ec17301dcfa1dfef1f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1404cfcbbe2c3948baa3388361eeb2be34b590fbbdfd090849e38a10a1eeadc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1404cfcbbe2c3948baa3388361eeb2be34b590fbbdfd090849e38a10a1eeadc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1404cfcbbe2c3948baa3388361eeb2be34b590fbbdfd090849e38a10a1eeadc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce42412109096343b27d56419cc3c9ba18e4012556f7f221cf727af8d00e1bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b4aa3385559f0ac14ce53cd7e1630f1e444dfd469b6b77a8ae8d6b2b8135c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4781293eb4e7feed7cb77184d0896c1e84f7416b90f20a220d08942606527910"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotun"
    generate_completions_from_executable(bin/"gotun", shell_parameter_format: :cobra)
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

    assert_match "GoTun dev", output
    assert_match "localhost:#{port}", output
  ensure
    Process.kill "TERM", server_pid
    Process.wait server_pid
    Process.wait pid
  end
end
