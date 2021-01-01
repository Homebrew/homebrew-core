class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.3.0.tar.gz"
  sha256 "4688b122ac05be39622aa81324d1635f1642e4a66d731e82d210aef78cf2766a"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3222f9fe082539e2786ff91c5cb5ac6cc2963adf34a061dd2fa9c381fa7c79f" => :big_sur
    sha256 "b35f2e90f232dcdb5503293dbc3e50edc597c74439489c426ea0392472466f72" => :catalina
    sha256 "b4455e76592e03211cca4a0331aa722021bad6d4ab2c69d0e4f70a9dca5ab317" => :mojave
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
