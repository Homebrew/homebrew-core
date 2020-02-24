class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.6.tar.gz"
  sha256 "8d692a1220a85884f231c3480e0da305678d86660e795a5eb510d076945adf65"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e114aa64f94b8e64b6b26e314a38443c42a793e7e3c6f246b9b7219d2c1c905" => :catalina
    sha256 "8e2ff51513713949c869457d39c787ae7f5f13ba75abc11561914378e59fbb11" => :mojave
    sha256 "43637e2a033c04ffc96dff95b355e2b99e0fdd263ff432498dceac9f305cc03d" => :high_sierra
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
