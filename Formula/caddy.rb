class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.1.0.tar.gz"
  sha256 "b5948b3fc1dcf65428756856b6c315dfb392e6cc0d78b7ad56ad334a81425440"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25fa330449c4557aae58459abe83f2f267ea318c160d4928ec45c1dafd15ab0c" => :catalina
    sha256 "2ed20d39a8156af3063375368aaa0bcba76ea30a7315ea411bbc303016b341eb" => :mojave
    sha256 "db75aa7d107b856930afed85918a4981c1bda90fba996171ac16e81c53963afb" => :high_sierra
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

  plist_options :manual => "caddy run --config #{HOMEBREW_PREFIX}/etc/Caddyfile"

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
