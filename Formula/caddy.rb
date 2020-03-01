class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v1.0.5.tar.gz"
  sha256 "0e7dc07e4f61f9a00a4c962755098e19ebf8c8a8e0d72e311597ce021b7a2a5e"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0a61a2b2b722b4bc23be979479785f6da07dd51cf5dff18791d0accdd6e65f1" => :catalina
    sha256 "a63d911c9dfc6832155bd9c70755185f69d8e238129644b2e9f0fc2436d260f3" => :mojave
    sha256 "e51157637abfcda12254807018d278ae804827b94d6797b105ee9599f3c2ef6e" => :high_sierra
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
