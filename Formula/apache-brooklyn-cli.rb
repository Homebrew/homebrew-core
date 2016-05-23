require "language/go"

class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client.git",
      :tag => "rel/apache-brooklyn-0.9.0",
      :revision => "bc8593a933fcb76327ae4a511643e39d25a87ba2"

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
    require "timeout"

    server = TCPServer.new("localhost", 0)
    pid_mock_brooklyn = fork do
      Timeout.timeout(10) do
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
    end

    mock_brooklyn_url = "http://localhost:#{server.addr[1]}"
    assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}", shell_output("br login #{mock_brooklyn_url}").strip

    Process.kill("KILL", pid_mock_brooklyn)
  end
end
