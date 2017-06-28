class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-0.11.0.tar.gz"
  sha256 "bc5bcabcf9d03d93d86d9f2599aef8adca8922c76ea2d01cc4ad9a70d466ca36"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ac3a2f8d7e4b693d5b14518a62babb75e45030b20146bcb943e5c24fbec7b54" => :sierra
    sha256 "c89f61f319611fba0ea65481fdd4ef794df26f86f1f14fd4cd954c3ee2f5182e" => :el_capitan
    sha256 "0466414150ef5273aaf937bebbca7a6890b485d2d59b31e823e3801d73c0c546" => :yosemite
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
