class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.0.tar.gz"
  sha256 "c3d73792a1deee527a4213e0b725a0caea8bb232c7e8e0a5162f2082bd86b368"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a28fce4d70533892f95837b1796e580639e12a3d152f2e609f251aa46ee037" => :mojave
    sha256 "f92481df4a5de9e1a4789a176b0dc6619fc9f4414319a6109ea508fd9e8c4f41" => :high_sierra
    sha256 "6483e7a8777afb98500189de965cf80ab213f3a7ae82ecbca416980bcb7b62db" => :sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sosedoff/pgweb").install buildpath.children

    cd "src/github.com/sosedoff/pgweb" do
      # Avoid running `go get`
      inreplace "Makefile", "go get", ""

      system "make", "build"
      bin.install "pgweb"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
