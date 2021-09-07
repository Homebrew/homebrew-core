class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.7.0.tar.gz"
  sha256 "fa46c33c2ae098d5f781a7b3dedf7c5044d5748fe3ffdf8ade46c1377a566599"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5804c6175628e8360fc20e187d1283fd9915448968b5bb29d3f2910614df22d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f07f34ebd6750c2df7120cda275b02a12315d27e8a6ac2cdd5af81fe507a410a"
    sha256 cellar: :any_skip_relocation, catalina:      "3bbce471b72391bce052279f861d1b8ea642b34e84c44ee8f6c9482b7ccf7add"
    sha256 cellar: :any_skip_relocation, mojave:        "0f1e0e2c3eab1bad6cf974e113a5c0114d6a38d1189211fb28cb64ca45652e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043d71d8aea6555fe3473dfc0d69bf7e265965fe5efa408326b41f1b165de125"
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
