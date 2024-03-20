class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.30.tar.gz"
  sha256 "b562a1cf28eaa2f30b15f00502ce06f84c19f487af62f9ad4b64bb184942cd56"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec29848186eb487b080a553cbf2d59e9a15195e46e1a19c0b44480a1d170d994"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d37e832bf4a14d95e57f1c8c0cc5fe64b401a1ce71fbb39cb9006cd56b1f36f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b287eb2085fd2868af88123c3407a6f239c06917d821876878478f76cf550a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d105db9b17d086139a796904de64d617acf3f6bfc59cf824572c67ab91ea44b6"
    sha256 cellar: :any_skip_relocation, ventura:        "40b183bf152c3a95090079accab256fc259b9b6c28fbad62dc19712f72cb9e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "c5003c6e397987be79e59df91797dbd21e1102b86220c85a0b9440cc4bb96976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7320ea7050604ef30a39cc6fe917360e4b65a72ef613db6bbde6ec7392f486a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
