class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.6.5.tar.gz"
  sha256 "3b0af8e8c42f077f8cf4fe62c8f0da7b9170c85930680135834bac2f0e46cbce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8aef958297b8b5830956a7ddc5963612e9e2c740352edd38c25df56a5580cb0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "929218c5e3d4f4298354d4f472d2d23d74c1fa646c4314ef9dd59806c7a19d85"
    sha256 cellar: :any_skip_relocation, catalina:      "48a4822d2b73eb0c26b40c556206768e0f622b19e419f496802118fabd6b98d3"
    sha256 cellar: :any_skip_relocation, mojave:        "6f48c8bbb360d16ac86763d0114c2f03bece2bcd0295c2e8ce8344b806f873ba"
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
