class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.2.3.tar.gz"
  sha256 "7994a9e61d4204cf10816aa9f3ebab4b9ae4a2d64a6f1ec1fe8a38b376e19494"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "186273c4f7f247081fc3876775d89d4d55c805f093853a359496cd1f1f579cdf" => :big_sur
    sha256 "6fe2b49e1ed11f60247932bae0f56db205844174eb5e7f9733bcabcd2a8656a5" => :catalina
    sha256 "1249e2364e8464f955f5bc444aafa7546e9db601d5cdeeaa8f6cc738dbb94acc" => :mojave
    sha256 "5322bd55245c5ba434837edea091008d696a1042f332dbd68b0244899d7d1011" => :high_sierra
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.6.tar.gz"
    sha256 "240eba5f525ab93264a75a78e576082c894d93e10622686c545710a90f9dcd94"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  plist_options manual: "caddy run --config #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist
    <<~EOS
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
          <key>StandardOutPath</key>
          <string>#{var}/log/caddy.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/caddy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
