class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.4.1.tar.gz"
  sha256 "60850f68c76043ad9581cb11de9eaeb35816b521301e61940f9c98d3f62f0650"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "970a0712c1d544a615b2fa826f6ce609216eac990c21079aa60dd9fc477d7a8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d222e8ef212b69dc705136f550d960ce0bc20d798f3a64a6869119531d25277"
    sha256 cellar: :any_skip_relocation, catalina:      "5d222e8ef212b69dc705136f550d960ce0bc20d798f3a64a6869119531d25277"
    sha256 cellar: :any_skip_relocation, mojave:        "5d222e8ef212b69dc705136f550d960ce0bc20d798f3a64a6869119531d25277"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.9.tar.gz"
    sha256 "399880f59bf093394088cf2d802b19e666377aea563b7ada5001624c489b62c9"
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
