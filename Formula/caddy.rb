class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.10.tar.gz"
  sha256 "aafaeb092e7b1bcff8ec31f19a1ded1253ff95cfdd4441378e5a530508614e8d"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e7f413950cb21d99caf541f932203fba671b5948e313335f7dcaa005036b29" => :high_sierra
    sha256 "009a907704d1968de79b0aadf5b9c0a97a400911b18730afaaa9d0faa84f697e" => :sierra
    sha256 "e1577fb37e85595b382d8de1a4d51991bee15bba368db23ac217025f035bccc5" => :el_capitan
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
