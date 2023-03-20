class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.14.0.tar.gz"
  sha256 "991ab58797d315d471cbafcbb665e3af4021654c88b6f916821290895956bb39"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0021201ec908439e83a295528480ad9d3e10ed1fe39b55d8c2149e093d3c3b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0021201ec908439e83a295528480ad9d3e10ed1fe39b55d8c2149e093d3c3b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0021201ec908439e83a295528480ad9d3e10ed1fe39b55d8c2149e093d3c3b7"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5a675d54ff5ef1fccb9a0467a1f0dbd7feb9435e02e28f73ff0a8a88ef860c"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5a675d54ff5ef1fccb9a0467a1f0dbd7feb9435e02e28f73ff0a8a88ef860c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa5a675d54ff5ef1fccb9a0467a1f0dbd7feb9435e02e28f73ff0a8a88ef860c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59715a76118efef9fac43e5c75de5b83c1ac305addd23c5b769559e015bd2e3"
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
