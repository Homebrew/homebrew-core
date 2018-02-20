class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.11.tar.gz"
  sha256 "c473121840532dfbe8e98b2663442c4a6602b684a5dc234081fdc41d98e0ae95"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "764556624afede510c1b9d0617fe49fc0df27b5cd03115e1d7c636ec94d41dc6" => :high_sierra
    sha256 "af2fcc1f10c1acab8b45cc0a6673298c44507532d4a82fb30d87fb41241ee438" => :sierra
    sha256 "ca6b157091c8b09eec98f04c73a03cf21f68d1af46dfe93916c8429b10902179" => :el_capitan
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
