class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.12.tar.gz"
  sha256 "89efdbd719c0a079d1ee3126d1a94292361199b88171b66b765ca31c12bd0ac1"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "faa9d8508d57c26392d685c4b6d27dedc23cbe1384a2bd6ee8197f8f74761934" => :high_sierra
    sha256 "9fd585a94ea28cfeb6eb942932dcae3a531eea0c95efa55cc1c92996da20f229" => :sierra
    sha256 "95f7cb1e8e6bbc0809fcfad5f15a32752f1a592d91203ed37687470049778dac" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    (buildpath/"src/github.com/mholt").mkpath
    ln_s buildpath, "src/github.com/mholt/caddy"

    system "go", "build", "-ldflags",
           "-X github.com/mholt/caddy/caddy/caddymain.gitTag=#{version}",
           "-o", bin/"caddy", "github.com/mholt/caddy/caddy"
  end

  test do
    begin
      io = IO.popen("#{bin}/caddy")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:2015/
  end
end
