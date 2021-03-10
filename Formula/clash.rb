class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.4.2.tar.gz"
  sha256 "7bd3708a071c4f78788dff96b9a4b187196976fe4079253f4af3d9db98145f1c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c8602fb4545b8993327001e4a228159c396f955d772ad607c53976b18e6a8a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "e16df74abf1aab103018ab24abe3d3e0b3313a04f58d310b55b4d5bd28ea3761"
    sha256 cellar: :any_skip_relocation, catalina:      "ac2df7fa84d0c351a99ef958feda9ae8aa208de2b6af2bf6264565dc647eec90"
    sha256 cellar: :any_skip_relocation, mojave:        "717763a425f9c90b2008828eeb31b58886980555f1ab8aaf5e5af014c6bd5269"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    system "go", "build", *std_go_args
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/clash/bin/clash"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
            <array>
                <string>#{opt_bin}/clash</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardOutPath</key>
            <string>#{var}/log/clash.log</string>
            <key>StandardErrorPath</key>
            <string>#{var}/log/clash.log</string>
          </dict>
      </plist>
    EOS
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{ss_port},
          "password":"test",
          "timeout":600,
          "method":"chacha20-ietf-poly1305"
      }
    EOS
    server = fork { exec "ss-server", "-c", testpath/"shadowsocks-libev.json" }

    clash_port = free_port
    (testpath/"config.yaml").write <<~EOS
      mixed-port: #{clash_port}
      mode: global
      proxies:
        - name: "server"
          type: ss
          server: 127.0.0.1
          port: #{ss_port}
          password: "test"
          cipher: chacha20-ietf-poly1305
    EOS
    system "#{bin}/clash", "-t", "-d", testpath # test config && download Country.mmdb
    client = fork { exec "#{bin}/clash", "-d", testpath }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{clash_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
