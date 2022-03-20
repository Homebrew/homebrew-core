class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.10.0.tar.gz"
  sha256 "40205e152ce73984a29f1888a1f235cb653f03a751ae5062b88b4b4076d5e87b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0698b5ab0a9ffc8fa9c788877cf1826c7ec4a5932a23d40ccc78768045a3690a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f252fa3abf913ee4900b75f15bfe3ae3e29dbead89ca61428fe2d372973570be"
    sha256 cellar: :any_skip_relocation, monterey:       "45e7eeddc565a7e30000262c572f3c24ab83bf4d8d88a297e9864990ddd4fd97"
    sha256 cellar: :any_skip_relocation, big_sur:        "c815badaf8c3cc07f92e2d4c467ce71a4618393f72071da2b6d67e066171f552"
    sha256 cellar: :any_skip_relocation, catalina:       "40a718ea22b51c5ed3ff6e3d4a6d8ec3f37769880f85fee6a9c9e034abb68328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305ae2c31442c910d08548ca810125b16344eabc73bcb8fd8ca8d67ed77adca4"
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
