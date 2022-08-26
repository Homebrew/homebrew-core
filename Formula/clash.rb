class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.11.8.tar.gz"
  sha256 "573fcf59648a4eee6ac8cd0a0d4717cc55f350beb866923749d343f17ff77f11"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be46daf0faa5044effd1e975acc07be3e4a87d60e196416bfa7782e8672693c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43b0f96c4898d3a98337a8c834751e23587725bbb5afec90cd725048c7d6509a"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe0d44f0eb832c93f92c2a0f7c21114a60c4da23b920296f9f19e87a5ad8e26"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9a2179d93de8d1bd19a0b3b349576ee83b3335563af11753fa25f7aa455b92"
    sha256 cellar: :any_skip_relocation, catalina:       "a3313b2c2697561cdaef4c2b3ac6b5c86de87127b8cfee2f75d46ee71fdd788d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccf2e521516101467e022f5cc60e0e0989d68804aa2a21140840d3514b59fdf"
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
