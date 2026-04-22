class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://github.com/Sesame2/gotun/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4448e9cd2efaf1ea5c1da50f39d3ea967632e15cffc36d2e1041f5c03b615750"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "994495478631ea4b296d2797d3ced7bc84d2f25294250fe9ce9ef45912f0c70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994495478631ea4b296d2797d3ced7bc84d2f25294250fe9ce9ef45912f0c70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994495478631ea4b296d2797d3ced7bc84d2f25294250fe9ce9ef45912f0c70c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a32a8eb26bfd2d3025a0dfdc2ce6df04dc14143c8715ca401173584f6800aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab06b3e858284bfd1c55b1f4ec7b60f04e6f52598525bc68bbf6393d26cae2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a728b8dc09e55b645cb2b34e7815ae184ddd3f6b421631cebf14528118a288"
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
