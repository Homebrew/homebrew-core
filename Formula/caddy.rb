class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.11.0.tar.gz"
  sha256 "81e593d258460a9f5c6b5a5f46890a08b6b1ce15f5c0fc7bcaf09826368c3a1a"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "898e5498690d8951290a80bcb5988f965ef0de03f9371784345abb8fac051467" => :high_sierra
    sha256 "c732041f4a4e55f9ade4e043eac13c3e7099af21072beba8131d6e82d71e6999" => :sierra
    sha256 "8ded8ce37d31009d0e5a810ea76320fcb7847cb317ceea2c60eadfff91eea453" => :el_capitan
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
