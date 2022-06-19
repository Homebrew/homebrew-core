class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.11.0.tar.gz"
  sha256 "551d6e1bfb87bb7bb7dc0cd36a763791d95d09a610c49544575baa1905b18986"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "491f3a817883a5d6e1ee6a494dcca37a9cde9c3ef67a0211e5d2ac5c7ecd3f09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b15e9e6824dadd17fc2a6d21f4b5d1ded92d4678d9f263b7713b1793f9315a36"
    sha256 cellar: :any_skip_relocation, monterey:       "5e54e36b2ace13d568ee6f5a94773f10997a334b004f0c600cfbd18c9e8b535d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3889c0caa845aacdad13c491244b9998de84b1650722db2306e58a425360df26"
    sha256 cellar: :any_skip_relocation, catalina:       "05d2b91d91be9dd14c5c0da3ccdd466445a769770e605c7ded346924b310b5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18768ab7943714e6a0b8d55fdb26d92f6e28f7e2ffe6855fcca02dbe5cb9184f"
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
