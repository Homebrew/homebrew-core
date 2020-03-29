class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-1.0.0.tar.gz"
  sha256 "9eb52ac3cd76adf219b66eb8b5a7899c86e25736294bca666a5b4e24d34e911b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7769a15fc55f1a6943165e78c0cc3c9677815686b935a888c3db708fbaf2b8dd" => :catalina
    sha256 "1b73cb46bdd10be0d426298ec972fd37362352b28fadb484374e701619d3a1dc" => :mojave
    sha256 "b64f20e59f179c2a359d180be65931e06743aea8c62295f58d1afdbd967871d9" => :high_sierra
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
