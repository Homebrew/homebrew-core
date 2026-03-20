class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.48.tar.gz"
  sha256 "a345a98dfc48fb3152e15f1f38cf26016abe8635fdfda472ea3ada28d8ad1516"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf0d5e9b0d421a79554f945f35aff48c52da6af096ed8fb2befd474195b0c496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0d5e9b0d421a79554f945f35aff48c52da6af096ed8fb2befd474195b0c496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0d5e9b0d421a79554f945f35aff48c52da6af096ed8fb2befd474195b0c496"
    sha256 cellar: :any_skip_relocation, sonoma:        "d91059eb771012797a4926e414817294c292254a8e7d36721ea48461dd847ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865d93df6f467635e6a8458986c1f54e58904ea9218e6537abc4591f3a5d80f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58cfa37abfed8c3b1bc4e0bea6ec71322a804ee7a038788e0825e0611c7e413"
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
