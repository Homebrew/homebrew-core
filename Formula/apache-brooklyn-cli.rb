class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-0.10.0.tar.gz"
  sha256 "9273a30e8fea9b5ebdd11ea64ff9164e03500660d4be26e2bc13e4e09c1c9ecc"

  bottle do
    cellar :any_skip_relocation
    sha256 "56c26aea57882969990487f455e378229238b1e49373e3044f50255c89d2fa16" => :sierra
    sha256 "4252ac91abef5c6c0026a0db2c8afc38b30d9af649620e6bf7b7e84a47e9a402" => :el_capitan
    sha256 "c9190a11e83e3a9bdc2d200125050c384dcbf1490549bf60059240a2f1882a38" => :yosemite
    sha256 "5bd6d72b2f1a91699f990bb9e3b09d743595909407a66edfb8f9436847958077" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/apache/brooklyn-client").install "cli"
    cd "src/github.com/apache/brooklyn-client/cli" do
      system "glide", "install"
      system "go", "install", ".../br"
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
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n", shell_output("#{bin}/br login #{mock_brooklyn_url}")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
