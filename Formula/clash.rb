class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.7.0.tar.gz"
  sha256 "fa46c33c2ae098d5f781a7b3dedf7c5044d5748fe3ffdf8ade46c1377a566599"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c90d81ea701b7fcadce5b962176ae440e06fa611d19658b452e7f6f8acfeed81"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f965e315816aa87cec7f8e931cc7be583cf0338eb18e8050fd5eae0dee10581"
    sha256 cellar: :any_skip_relocation, catalina:      "e8ed687b2eea61f85e4561c8b8bc2bc3302bb50a2e5e1c14ce02eaa26944ceb8"
    sha256 cellar: :any_skip_relocation, mojave:        "150a79b37a7c0b5e02d000a9ef1ec712e09ced464f9cc760df5400fd4d210338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c4f3ee50cf3b7015e9a626737db1a3623936197de534045d5aac5d185e33272"
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
