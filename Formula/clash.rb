class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.17.0.tar.gz"
  sha256 "cd30a27f801652151eea129e9cb00e4a3ee28d45982dad835f4546691796d9d7"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71df21e3fa07016bb64720da36901e7cd91f4a18ce85b540faf4cd2c08af6054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71df21e3fa07016bb64720da36901e7cd91f4a18ce85b540faf4cd2c08af6054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71df21e3fa07016bb64720da36901e7cd91f4a18ce85b540faf4cd2c08af6054"
    sha256 cellar: :any_skip_relocation, ventura:        "0143a67dc96ada77e575e1286f5ed3892d08e3dc36d1efa6856347ab45384c65"
    sha256 cellar: :any_skip_relocation, monterey:       "0143a67dc96ada77e575e1286f5ed3892d08e3dc36d1efa6856347ab45384c65"
    sha256 cellar: :any_skip_relocation, big_sur:        "0143a67dc96ada77e575e1286f5ed3892d08e3dc36d1efa6856347ab45384c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d33f7c551a2606ee5ed5d2a147513327ccb9040b87df7752d586b1bee569355"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/Dreamacro/clash/constant.Version=#{version}"
      -X "github.com/Dreamacro/clash/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run opt_bin/"clash"
    keep_alive true
    error_log_path var/"log/clash.log"
    log_path var/"log/clash.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clash -v")

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
