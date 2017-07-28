class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.6.tar.gz"
  sha256 "89c0276bfbb85bd1a42af9eded31b8e16851555decf34cfd53d86215ef2cfd06"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bbfb8b53d05acea0487e08238e867947bf53bf36ddbf04a6dbf053ef26bb93d" => :sierra
    sha256 "a03b0f7f67928ca652db46be9dca22920277bb7fee28757fa9b3f1a349303679" => :el_capitan
    sha256 "17cb98637b09dad6a2cbe3037a44a3fdb90e4fbe925e462a1c8fbd0d9bf6b4ee" => :yosemite
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
