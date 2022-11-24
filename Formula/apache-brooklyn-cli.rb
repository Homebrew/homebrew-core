class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-1.0.0.tar.gz"
  sha256 "9eb52ac3cd76adf219b66eb8b5a7899c86e25736294bca666a5b4e24d34e911b"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/apache/brooklyn-client.git"
    regex(%r{^(?:rel/)?apache-brooklyn[._-]v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f68cb32eac244ea9a7745802db86ededbf56a38abbbfc6d3d1306164985cea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28a0de7403bde7b164029cfd960cceaf1a10353381e486619cee2a14e917969"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1294ffaaa4cebe9accd9686c723154f18b0c132200eddcfaefc9ec69cfc47b57"
    sha256 cellar: :any_skip_relocation, ventura:        "e59986c652c07c7b7f255d1e723d6d16a993bc35561d563126ebe0889b311763"
    sha256 cellar: :any_skip_relocation, monterey:       "29f3308f69c65811e229ab4504c1db3c7d313c66ea2c46453413fecfd511ca9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee39617c71638a87e473fe90b002d6d1ab34d149a40218cb53758ca08e162593"
    sha256 cellar: :any_skip_relocation, catalina:       "7769a15fc55f1a6943165e78c0cc3c9677815686b935a888c3db708fbaf2b8dd"
    sha256 cellar: :any_skip_relocation, mojave:         "1b73cb46bdd10be0d426298ec972fd37362352b28fadb484374e701619d3a1dc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b64f20e59f179c2a359d180be65931e06743aea8c62295f58d1afdbd967871d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4c4477e4bf83026dee0febd6eace59fe1d0c0d015074b283317131cae49e42"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/apache/brooklyn-client").install "cli"
    cd "src/github.com/apache/brooklyn-client/cli" do
      system "go", "build", "-o", bin/"br", ".../br"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port
    server = TCPServer.new("localhost", port)
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
      mock_brooklyn_url = "http://localhost:#{port}"
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n",
        shell_output("#{bin}/br login #{mock_brooklyn_url} username password")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
