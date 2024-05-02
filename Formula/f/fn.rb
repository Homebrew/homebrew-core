class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.32.tar.gz"
  sha256 "81156cc2be54c4b1d5d10110aff82e89e68c730fa2845afbb64cf675bf2c6cd1"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cd174f098888b7fdd159c19314758052fa4aa631a8d4eeec84d2dfc460b67e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb4b93a3773e3fc8c34d605ebb52f0bad02a8306c4d096153cf1ac2d69eb58a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3306163770ddc7c8ab0f25f827287a083e13dc46b6237df1c4d82f2b867c3829"
    sha256 cellar: :any_skip_relocation, sonoma:         "63aba99e3aa8c456df1e1de52fd442dab954b6fe953594400fac433fe0e5f2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "d62a85472c41624cb6a02f8e513fd52b16f0bfd6b0c24963aa2625f5d2d68cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "f64ce0af373319eec3363660f3d0e9fd69b89c19af0ad1d8d98b58f8ed4b3721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4e6ac9b3612166475a7fce4149154f37e044745d0a2d369c4b22396d8b7e38"
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
