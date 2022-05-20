class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.10.6.tar.gz"
  sha256 "b56c6f978f43257da2663b8e11c219d08c16bbfc7704dd8bfdd8c4006f138c0d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34196d34c0ee16c6a872fdcd7df29fea97445253e962249d077552d822c3ddd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d0438a3ad0313b2db6a818e03673e9c7454274d97fe1a36afdcd082753cd780"
    sha256 cellar: :any_skip_relocation, monterey:       "90d074d20218891c6419dbc3406036b8e708e3066c653037c51c57334bf9849e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3645ed2d555887a75111779f55c3e45683f96cf035fcdb9bc18126c8ce653406"
    sha256 cellar: :any_skip_relocation, catalina:       "eba78574731cbde72761df21e820e77c8589638b390b3581fd3ede0a6386c0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407310845fef3c1820d336c0df07190568ab7600a9975fff22cc0c047d87667b"
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
