class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.6.tar.gz"
  sha256 "8d692a1220a85884f231c3480e0da305678d86660e795a5eb510d076945adf65"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c2b16bfbaf05d845ee3fed44040940fda9c7e6ac715c77b822ef5e5cc46bd24" => :catalina
    sha256 "94d27f7b82dc0cd81b8f396bfdc5f60aaaff808b5958ae869b5e7708394c0cc9" => :mojave
    sha256 "226cc86baf7f47f8c38688157e11d70d79a305cd1632f9c638e5936759f59f10" => :high_sierra
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
