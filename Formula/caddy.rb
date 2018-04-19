class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.13.tar.gz"
  sha256 "34e25c1e91c5916803d3004407b27a30f0a32fb58511323c8dccd3cace8246f6"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89a2be8d6029f38cac152347697b38d13ad68151ceef692b3143268dab89b424" => :high_sierra
    sha256 "1ba88738ac4e56ce21d11c7d446724235d9fe7409916155ff0380ffcaa4e8816" => :sierra
    sha256 "c2be69441b83defcc2ef8c21cd2ef906f2b791a3ef7440e1fef08462ce069896" => :el_capitan
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
