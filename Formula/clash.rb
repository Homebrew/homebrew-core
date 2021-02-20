class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.4.0.tar.gz"
  sha256 "48296a319472db6e4afbc7a1d3970c8fb13cbfe799c36a3ca9c43029f9a89200"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d35a55b1162bc59eb003d354357422f09dada2bcb536f4f4c3222759c2535d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "3106fd67b81a7e776a86d5a370a368673f572e16041026d6164ebfd35b61d957"
    sha256 cellar: :any_skip_relocation, catalina:      "3984135924eb632b727f56aacf7e422f59811ae6039198f92270121d0793dfff"
    sha256 cellar: :any_skip_relocation, mojave:        "f8332a4a2a1bb68756b6cb5cc29053659c040aaff845e2f1102b69e69edc9721"
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
