class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.8.tar.gz"
  sha256 "3328efc8b64a428d49dd27edf44c0b1d9dfdc8879366663ce002bafc3a7b2b90"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f01e9029aac5d997fca341779bf8f415fe1d542aa69973c2374c12f942a7d945" => :sierra
    sha256 "53ac6d2b1afa51d01a931fc7a56398222cf4519badf535d60511c244e717b6e4" => :el_capitan
    sha256 "bfa547815153c8fe9571565053f5f0e86de770ec8c43aba9cc5878fa65fea53b" => :yosemite
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
