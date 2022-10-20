class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.11.8.tar.gz"
  sha256 "573fcf59648a4eee6ac8cd0a0d4717cc55f350beb866923749d343f17ff77f11"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f497627bfc920ab5be613c1046aad44d21c8504e4231c12f02d4e069b0fb1c53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc1169b117fc0169d329b29e784f9da217372886f58fe727f203ba6552222d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "fe1ee5f41d56b631eb58c7119323729b38c648c2001afaef5d150ddb9a1ddab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc9ddb4b7929ebf0e340b1c34e2059208121ffdcb12f59782a0225e6f2bdfa0d"
    sha256 cellar: :any_skip_relocation, catalina:       "8148404c9490f83b5bb942c0605f522ef179389e728f6fe6a57b23b37d7a28b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1643ca6e61f1e624161e8ed80387d956c8f1f2c864c4dcd3c3d35d3bdad7c327"
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
