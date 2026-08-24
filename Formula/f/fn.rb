class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.63.tar.gz"
  sha256 "764eaa60ad7dc3e8daf25c28753392af178b1e47ac08d12c43e1d8e50ed7b20d"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2c2d0022e5397b8e57de69fe0d17181c8ba79f40ee161070fb845297c29c39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e2c2d0022e5397b8e57de69fe0d17181c8ba79f40ee161070fb845297c29c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2c2d0022e5397b8e57de69fe0d17181c8ba79f40ee161070fb845297c29c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "47513e7ee26d546953a30e912a9fffd05406f1c81a95548a72fc0acac6734580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cddba1916be0055bc875d91902d0ef89b6cf2725794ab82badd405ca12cf4a8"
    sha256 cellar: :any,                 x86_64_linux:  "f78b558a53ef1eb97e88fcd8678f309189ca6a642270861807faba96ad191faf"
  end

  depends_on "go" => :build

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
