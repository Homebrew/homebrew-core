class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.15.1.tar.gz"
  sha256 "c340f30a244599692bd8c726ece292184ef9cd8910c622cdd41bbe695b283136"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "677e0826505a064d7c05a2a214fcb48b18efd4e243aa38fed1f99712d400a3fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677e0826505a064d7c05a2a214fcb48b18efd4e243aa38fed1f99712d400a3fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "677e0826505a064d7c05a2a214fcb48b18efd4e243aa38fed1f99712d400a3fb"
    sha256 cellar: :any_skip_relocation, ventura:        "175e7522bb8d6fba1dfc41fdc76d14afdb7d3683bfc53d77a3f219ac11ab74da"
    sha256 cellar: :any_skip_relocation, monterey:       "175e7522bb8d6fba1dfc41fdc76d14afdb7d3683bfc53d77a3f219ac11ab74da"
    sha256 cellar: :any_skip_relocation, big_sur:        "175e7522bb8d6fba1dfc41fdc76d14afdb7d3683bfc53d77a3f219ac11ab74da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4de5de37873c81f4e1f834109211f7d68096b5e7de4afacd68ed9855b8b5c49"
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
