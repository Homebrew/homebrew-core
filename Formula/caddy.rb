class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.1.1.tar.gz"
  sha256 "77beb13b39b670bfe9e0cc1c71b720d5b037cca60e1426a9a485bbfae34ba8d2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "847028dd3f176fb48afa9006530d98df57f355ff6bdb5a985d274b7ff45882f5" => :catalina
    sha256 "002970585ed938b177d25c97828246f85ca2a591381c13d0f4c41a7f0fdb6bad" => :mojave
    sha256 "db60499319ccada5f3a2a0c16b8ea86c00369b876a7491ba62c7b011db54e526" => :high_sierra
  end

  depends_on "go@1.14" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.3.tar.gz"
    sha256 "160244a67fca5a9ba448b98f4a94c6023e9ac64e3456a76ceea444d7a1f00767"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision,
                                                "--with", "github.com/caddyserver/caddy/v2=#{buildpath}",
                                                "--output", bin/"caddy"
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
