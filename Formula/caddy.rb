class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.12.tar.gz"
  sha256 "89efdbd719c0a079d1ee3126d1a94292361199b88171b66b765ca31c12bd0ac1"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1c3cc8ab3f01b4ef582803de7569b584bdabd80c647daba621c078a9ca7616f" => :high_sierra
    sha256 "3203662bac9ff41ac4a05f6cf5dcff50a5aa4705ad56895a9dc10d270808a272" => :sierra
    sha256 "a3a37703edb975d52325359377ac8e358519724daf884749496150084d9fc2c3" => :el_capitan
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
