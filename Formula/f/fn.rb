class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.61.tar.gz"
  sha256 "7542e671bd8128cf5c93d7570570ce164dc9c81cc8962d7bfbf93f47935aad22"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "590973a92519f9b070a8220826f7ca235e3a6676be036d81cb3b00adb52fa692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "590973a92519f9b070a8220826f7ca235e3a6676be036d81cb3b00adb52fa692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "590973a92519f9b070a8220826f7ca235e3a6676be036d81cb3b00adb52fa692"
    sha256 cellar: :any_skip_relocation, sonoma:        "79c232e633e2dec26d7330f5aa45df4565cc2d1dcead2521753b952b03b58242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd88378b976aef154596f97f510a67fdddc0f940a8e70f15685b06a58d7e327"
    sha256 cellar: :any,                 x86_64_linux:  "c9ef528f18ba610dbe2d63403afb926a62c3fd336f2678ca6773dc658b775a0e"
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
