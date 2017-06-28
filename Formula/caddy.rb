class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.4.tar.gz"
  sha256 "411e6bf10520e938712887a31f2132bfd19e2c79543e7aef158f7c77d03ae2bf"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "502ad1d44b0e5ca5b87fad51cd07f06e98e96d76d00da752ff023eda19a92ea2" => :sierra
    sha256 "216481a742e48a77399f059f558c08c8a14cf23cdd9f0750fb25f54e2a7f0e9f" => :el_capitan
    sha256 "f2aa465c973171b89b5bbef550a8910ab699987db33ad77344fa21862ddc5804" => :yosemite
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
