class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.8.0.tar.gz"
  sha256 "e1bae0ba88a0e2ba36702f95fe95fdc8fee58db4751b5b108ea600563c36a972"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6349fc7faf36bfb72e0c6cd7cfa36efdb81bc22392f843016571c95a13a6faea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "988485cbdfccccf425e71d62911e04c5bee3c779fb2afc7993fdc540284bc62b"
    sha256 cellar: :any_skip_relocation, monterey:       "2231213d6c6c060a16294f8ef65653df822b9ba9e664777520c78e48a0227dcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f603b0ab23db593f16c4969f35a58b507d961d7cffb6d77633a07e4fdc64920b"
    sha256 cellar: :any_skip_relocation, catalina:       "dc3049707d46c50348c0c9d4d6c3401a405aec0566624c4734c4b254a6017f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bec8cd613cbad95baed12ce74ef6e84a5adf8ae1206eb0e358b526f8fee9492"
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
