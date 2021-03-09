class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.3.tar.gz"
  sha256 "ae1b1d833a83e5666f529e809a4e3ea4f690842f02ab9934dca868d704241072"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "307acf7937fe51a13e79400b15510877a8004c9a4e5da6734eeddfc126c86901"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ca32e7eebd502f925986f1e3c8033afd2fb830b40c08b9fa104171a7aeabdef"
    sha256 cellar: :any_skip_relocation, catalina:      "46525248fd7c40edb3be0a5e6d7994b40fe755e35ac353a3e862cd55deb4c4b9"
    sha256 cellar: :any_skip_relocation, mojave:        "eab657e996f50030c3dbb1c76b1684dd3ada11bcc96165909daefe8401c32356"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/fn"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        socket = server.accept
        response =
          '{"id":"01CQNY9PADNG8G00GZJ000000A","name":"myapp",' \
           '"created_at":"2018-09-18T08:56:08.269Z","updated_at":"2018-09-18T08:56:08.269Z"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
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
