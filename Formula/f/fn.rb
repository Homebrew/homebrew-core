class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.34.tar.gz"
  sha256 "136c9783b6ce10194bdcdebc8aa28ab15efce7d623b33fe0620a9cf32b8b97d7"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "214e553bc5dc60430659ab134923b1fc4d563f943991f7a1497fcef78a9a909e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb96ee5b5378ffc71a777074b3356ee88bce54ae046f0cb19060236643e0a4a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1774841f8fa3f267b2e07fe14c947088b613fa2102fbce9bfe19dabc0a0ba479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c983120de02048e7ffe6557266e0f81d57b19a046090e04af3c9930c7e981a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e596a7e0be60952a48de68685a86e027ebb146502564b45a0c035ab6979cc545"
    sha256 cellar: :any_skip_relocation, ventura:        "e150e791b0ded1e44021333af844049bf24abadd8f619ea8e48beb72b9a629af"
    sha256 cellar: :any_skip_relocation, monterey:       "c756bbeaeb6874e86a85118c385ca8369ec2dbd45f50a8b4863649df856d00d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58fd86c06271ae9046fd5d367d8452e0ccb940e103a4536279d876d13283e44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
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
