class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.3.5.tar.gz"
  sha256 "89f39540a698fab82728c80e903d7750894789621595ca11a4777afdfc3e265d"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3c6497c1d3b6f6c4c7c8c611a964d2d9acf54fc7e0f11e1f4b7ba0cfc1bb75f" => :big_sur
    sha256 "6ce4ec8d6dde665215579c54584fd38fa8c17cb8876c24608afdbd8b3748cabf" => :arm64_big_sur
    sha256 "05c3cc38443156b857ba98ec54b8b7ba413d464ec76aad2283487560fa687599" => :catalina
    sha256 "bbc2a5cc2abc096ed91ca251a2fcac994fc8ecd1c327472eaa5bfdf67f074c77" => :mojave
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
