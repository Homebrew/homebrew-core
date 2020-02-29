class CaddyAT2 < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.0.0-beta.15.tar.gz"
  sha256 "9d1992f80a7c8c4a6c3784396d5345e8cb64c412581eee14cce1921258e2cc9d"
  head "https://github.com/caddyserver/caddy.git", :branch => "v2"

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    Dir.chdir(buildpath/"cmd/caddy") do
      system "go", "build", "-o", bin/"caddy"
    end
  end

  plist_options :manual => "caddy run --config #{HOMEBREW_PREFIX}/etc/Caddyfile"

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
          <string>run</string>
          <string>--config</string>
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
      io = IO.popen("#{bin}/caddy run")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:2019/
  end
end
