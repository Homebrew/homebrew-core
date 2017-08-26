class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.7.tar.gz"
  sha256 "5693045653e15f92f28ce944690162a4897079b7e98d3c9c46e0907d08049ad6"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4abfbf0a4a2b83f92e25d207ec2d7c40273b2a117a45a2ff0526eb13a7021f24" => :sierra
    sha256 "d16a9109c2cc999dee71a3377d40a9a4c59c81bd31db8a497e98a6a12b1c5282" => :el_capitan
    sha256 "79952ae6f038548b3d67330b9681ec90cfb5cf34ecace2fc0b2135cb5a5eab10" => :yosemite
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
