class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.74.tar.gz"
  sha256 "c3eaeb3498f446e9b7217a5b76400c5d11f57ceaff84826ea8b1da6e9f668949"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    manifest_sha256 "e611ed1854645767477d1a2e2688e0bbccb1feb9f76c412ef57d10036ca75f76"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9782cd4bc78e47e290165737b22a632a548c8613dd86b3cdc0f88278a1aea0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9782cd4bc78e47e290165737b22a632a548c8613dd86b3cdc0f88278a1aea0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9782cd4bc78e47e290165737b22a632a548c8613dd86b3cdc0f88278a1aea0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c8535df2e83c22466aabfd368bc9c779ee9523cb75e557df2a417d4456d4d76"
    sha256 cellar: :any,                 x86_64_linux:      "160ec95a4eef16bcf28dfc2d543ea96ea2834dbfd95d628259f06d980fdf60fe"
  end

  depends_on "go" => [:build, :test]

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
