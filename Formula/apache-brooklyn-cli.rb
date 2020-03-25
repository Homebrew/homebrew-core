class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-1.0.0.tar.gz"
  sha256 "9eb52ac3cd76adf219b66eb8b5a7899c86e25736294bca666a5b4e24d34e911b"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc1c638f30c4036519eff703b605de6d22313970e585576bcf16183381f59247" => :high_sierra
    sha256 "b2ad53984d4e98ef3d37622ff0ff9dd987f4ecc2614e251f3df60de13d96b6c2" => :sierra
    sha256 "39f56956e1ed81dfae64401caa333f910b70312d6e45950ac5e2bb3c0db59cfe" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/apache/brooklyn-client").install "cli"
    cd "src/github.com/apache/brooklyn-client/cli" do
      system "go", "build", "-o", bin/"br", ".../br"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new("localhost", 0)
    pid_mock_brooklyn = fork do
      loop do
        socket = server.accept
        response = '{"version":"1.2.3","buildSha1":"dummysha","buildBranch":"1.2.3"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: application/json\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    begin
      mock_brooklyn_url = "http://localhost:#{server.addr[1]}"
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n",
        shell_output("#{bin}/br login #{mock_brooklyn_url} username password")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
