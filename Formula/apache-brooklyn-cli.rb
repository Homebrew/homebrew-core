require "language/go"

class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-0.9.0.tar.gz"
  sha256 "873804a145aed33de86e3928df05bad31a921f73984fed06ecdeb11e799d9c01"

  bottle do
    cellar :any_skip_relocation
    sha256 "4252ac91abef5c6c0026a0db2c8afc38b30d9af649620e6bf7b7e84a47e9a402" => :el_capitan
    sha256 "c9190a11e83e3a9bdc2d200125050c384dcbf1490549bf60059240a2f1882a38" => :yosemite
    sha256 "5bd6d72b2f1a91699f990bb9e3b09d743595909407a66edfb8f9436847958077" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "5db74198dee1cfe60cf06a611d03a420361baad6"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
        :revision => "1f22c0103821b9390939b6776727195525381532"
  end

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath

    brooklyn_client_path = buildpath/"src/github.com/apache/brooklyn-client/"
    brooklyn_client_path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/apache/brooklyn-client/br" do
      system "go", "build"
      bin.install brooklyn_client_path/"br/br"
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
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n", shell_output("#{bin}/br login #{mock_brooklyn_url}")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
