class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.5.tar.gz"
  sha256 "4e54aff931aa42565ae49dae2c9d8f5654d8b1a410eb6be70035d68561f6265c"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34865eaefaa7562f8f489c75d62428eaeebf69154a7eb85ffbe03a725ec90012" => :sierra
    sha256 "cab785f7aaf02d252c22bd4b09518166443394869a3cc9701770d4251c90e24c" => :el_capitan
    sha256 "71bfe0b9a1f4039d107327d5558b89cbb7cf67d70f3edd486a9a912d0112d1e2" => :yosemite
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
