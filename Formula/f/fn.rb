class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.43.tar.gz"
  sha256 "49e2a099d9c8d22fde6eacd402f76532c642c832195810f0291e3b6fa45786a8"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ec63b50ca03100dd5c9e2d1f59f14237fd304520e14c963070a61b32ed93b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e284eabf4799ad4175683065ccbd8856a01e7726950ffec1b3137080ead1edeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e284eabf4799ad4175683065ccbd8856a01e7726950ffec1b3137080ead1edeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e284eabf4799ad4175683065ccbd8856a01e7726950ffec1b3137080ead1edeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "95800a2b61242016d9af1066ed1ce21e1dddca3fb37c7a897b847ce3620017c4"
    sha256 cellar: :any_skip_relocation, ventura:       "95800a2b61242016d9af1066ed1ce21e1dddca3fb37c7a897b847ce3620017c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9b603653b1e11e063c8657dde89cea7a0fc8fac2cea5014bc2c07a6aa05cd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
