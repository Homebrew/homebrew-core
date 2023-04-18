class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.24.tar.gz"
  sha256 "ef59de4cacfd4c9e17b6f31937e889faf82fbf0d4e003f1b83de71b5c965015d"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7755be5fbf98065deba04682eea2d99a54c248da95c9dfa36f709d674942467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7755be5fbf98065deba04682eea2d99a54c248da95c9dfa36f709d674942467"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7755be5fbf98065deba04682eea2d99a54c248da95c9dfa36f709d674942467"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd0d1eea1f603adf4d6c60fdc1fb4eb793bcda76367fb41c1f1c5a3cd77c756"
    sha256 cellar: :any_skip_relocation, monterey:       "9bd0d1eea1f603adf4d6c60fdc1fb4eb793bcda76367fb41c1f1c5a3cd77c756"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd0d1eea1f603adf4d6c60fdc1fb4eb793bcda76367fb41c1f1c5a3cd77c756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ccc42cd95bba508188021c8cb7a64747d34ce6a68b74b2d477282b19bd3657"
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
