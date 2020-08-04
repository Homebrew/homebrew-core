class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.1.1.tar.gz"
  sha256 "77beb13b39b670bfe9e0cc1c71b720d5b037cca60e1426a9a485bbfae34ba8d2"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "602b81872d922b82c774674e7adcd62057faebc79ba3e625dd428f985aeaa4a5" => :catalina
    sha256 "2c5fefa2bc48ea2e0ba42f7940f8fb8282f74c38a63a92708ae67c6854d0d365" => :mojave
    sha256 "96b8d15646c1396a1a28b583a7c13a2311bad789cd50e70c5499b74be7c4bd8e" => :high_sierra
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.3.tar.gz"
    sha256 "160244a67fca5a9ba448b98f4a94c6023e9ac64e3456a76ceea444d7a1f00767"
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
  end
end
