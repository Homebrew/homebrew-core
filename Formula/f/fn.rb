class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.41.tar.gz"
  sha256 "59476079a63d3a9794f789a594301e39f7943eea40b199f95c3f55ad8ddec006"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28383e77da5e24ef0999da1e90755db7745b1f3ab0c72ee7711ab3e674685371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28383e77da5e24ef0999da1e90755db7745b1f3ab0c72ee7711ab3e674685371"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28383e77da5e24ef0999da1e90755db7745b1f3ab0c72ee7711ab3e674685371"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5e7f9bc664e982ba50111e8727136a55f7af3fd5d156490f61a81252b8f618"
    sha256 cellar: :any_skip_relocation, ventura:       "2c5e7f9bc664e982ba50111e8727136a55f7af3fd5d156490f61a81252b8f618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410a3f3284bdc99b97e3facf8b3c7fce1855186ca0bd87c9a09064e917ae00bd"
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
