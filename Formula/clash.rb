class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.10.0.tar.gz"
  sha256 "40205e152ce73984a29f1888a1f235cb653f03a751ae5062b88b4b4076d5e87b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867828656f1a2bc537f50c32711e4a87570d65d7324ab63f1102fee1915522c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3edc4136aa8e9f84660e64ecec0148e1624c44112d01973c52ed65f01c176353"
    sha256 cellar: :any_skip_relocation, monterey:       "ad6f2448b0070b71cc2ba8e8f08d7c3377ef40054d8553e542ac5c4c88c1157d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f09091851bcf493a939d9ff2762e759ba7f5fb86fdbea48aebc0653cff6fc043"
    sha256 cellar: :any_skip_relocation, catalina:       "1376d888dd1a891503122f4dd432040233ffffa5538876b28b44a843a5e8977d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de29ac1d261906e1905ecadb3a9d1f671f962c38e58ed5144f4b59f06be7dda"
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
