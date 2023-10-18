class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.26.tar.gz"
  sha256 "dc57f9f93c1a4c7c8f9c88b7089b8e066cfb4ca79f48f9aa1dd972ceabb980bb"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5de4c56571e32883fb9a493cc2b36f1579cb6b02babf8fc0b37e3609b2977e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b803c5a7f1f72b3369f0200c42db5075429886c5df54a1b362dc12c37af74a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b803c5a7f1f72b3369f0200c42db5075429886c5df54a1b362dc12c37af74a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b803c5a7f1f72b3369f0200c42db5075429886c5df54a1b362dc12c37af74a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d271d3a71a2c78bad46de45ed5535baff040fef5f090120c9381a1da3556f07f"
    sha256 cellar: :any_skip_relocation, ventura:        "52efc1bc9787ce872dab71ad180777e55ebc0d9ebdf11238b469e0f93793d73a"
    sha256 cellar: :any_skip_relocation, monterey:       "52efc1bc9787ce872dab71ad180777e55ebc0d9ebdf11238b469e0f93793d73a"
    sha256 cellar: :any_skip_relocation, big_sur:        "52efc1bc9787ce872dab71ad180777e55ebc0d9ebdf11238b469e0f93793d73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d804cb9db019c4ff38e2cc3531259bd07f29f1f8256bf7f6252837dc61b8b204"
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
