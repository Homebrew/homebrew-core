class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.5.tar.gz"
  sha256 "4e54aff931aa42565ae49dae2c9d8f5654d8b1a410eb6be70035d68561f6265c"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebfaf57f3a1d0f9fdc5d3f2579a6675694569e67b06c32ba2f5dd583b3bddb39" => :sierra
    sha256 "7fa0e4998e8a441a046ceeed23de14dbc665031b347c40ca9eafad1ff4101cb4" => :el_capitan
    sha256 "a1714048609874f9902729abc8b83c2c83a57471a6c877a7bce7e31a32b208e6" => :yosemite
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
