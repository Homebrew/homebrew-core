class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.7.1.tar.gz"
  sha256 "18c2ef10df608392435a1277d3f2e256c65bec3662bf0a6c325f02be6deb4fce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "066bc9085115b2e13a4c99634c973948a566d143b32f6c553648ab73adaf1739"
    sha256 cellar: :any_skip_relocation, big_sur:       "c59f2f4aa03a106b91181dd74c3daebe7e4297191af08fc0f7142cf9e5ecddfb"
    sha256 cellar: :any_skip_relocation, catalina:      "92897457668e09639ac0b83af976a4c3465bee0af6aa51d10712cb072e8f7c2d"
    sha256 cellar: :any_skip_relocation, mojave:        "c1e9f88565f1427609c7e432a1b52f6027c649fb223087ba4cee1bd87f48bf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354c75ab99d2b9ea7bae268db11a6028d1590c09a82cd8aad9adad2741f6ff54"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"clash"
    keep_alive true
    error_log_path var/"log/clash.log"
    log_path var/"log/clash.log"
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
