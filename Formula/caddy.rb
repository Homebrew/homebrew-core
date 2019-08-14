class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v1.0.2.tar.gz"
  sha256 "bdfefc0dfee259424ffd14fcafd4502361e5bd63a017208e83e333ad0b597630"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cac8f4f51435723f61976040bb05f6e07aeaa7b668c8b80406b3d85640a61ac" => :mojave
    sha256 "5a4441990a71c6d94ca44da693457ccd2917e3af63de125f7e3e029e6427b81f" => :high_sierra
    sha256 "0959f64f135d8b12c1bd5b466e449b0d5b57c962268c1b38179175c980f32fb2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/caddyserver").mkpath
    ln_s buildpath, "src/github.com/caddyserver/caddy"

    system "go", "build", "-ldflags",
           "-X github.com/caddyserver/caddy/caddy/caddymain.gitTag=#{version}",
           "-o", bin/"caddy", "github.com/caddyserver/caddy/caddy"
  end

  plist_options :manual => "caddy -conf #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/caddy</string>
          <string>-conf</string>
          <string>#{etc}/Caddyfile</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
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
