class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.73.tar.gz"
  sha256 "93452a52db5d67dd365b4d17244a0cfbac9290aef92729e3a1b4ce20f3cf9af5"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f819a0103bb06d024a0f8f15e2aad3a9e7858508e882d945d697deb12b632b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f819a0103bb06d024a0f8f15e2aad3a9e7858508e882d945d697deb12b632b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f819a0103bb06d024a0f8f15e2aad3a9e7858508e882d945d697deb12b632b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "517ab567b4bd59f60f28c9aa511ed2c2e9777df36798505de9b1aa716e09acf0"
    sha256 cellar: :any,                 x86_64_linux:      "de020764c7738da074b0d82be2b98170095ecdabe8ad8f0f08d497fef20edc70"
  end

  depends_on "go" => [:build, :test]

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
