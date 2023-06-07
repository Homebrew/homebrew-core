class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.16.0.tar.gz"
  sha256 "671d9ad8582593478945e13a052d4b462e0935ac50d5bb71fa2bdf2fa16893ea"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180a09500bce437e397790e5e11fb5db78076986b487bc28272befc97bcadd26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180a09500bce437e397790e5e11fb5db78076986b487bc28272befc97bcadd26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180a09500bce437e397790e5e11fb5db78076986b487bc28272befc97bcadd26"
    sha256 cellar: :any_skip_relocation, ventura:        "435e870599257e67bdc9d8f44297c72fee5e2a135988eb1b722bd1cd9cc516fe"
    sha256 cellar: :any_skip_relocation, monterey:       "435e870599257e67bdc9d8f44297c72fee5e2a135988eb1b722bd1cd9cc516fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "435e870599257e67bdc9d8f44297c72fee5e2a135988eb1b722bd1cd9cc516fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a69765b964fda4b890dae4c110d753a1b8c6baf814a89702f7cf78d4941c24d"
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
