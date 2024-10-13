class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "139794f50d3d94f438bab31a993cf25d7cbdf8ca8e034f3071e0dd0014069692"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c44c3dbd296cdcbe3b6d0a579244bea03111e8d6c4e9f509f513a6482bb082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc16caed4749ba51377dcc1862b5d78fde86c93e1d5b03d9930855a8e419d12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee5031299250c21619a266efcbae83c135e10c0c1ac4c60f8cbecef43bc8ab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd2b278309f408490a2a28ccda720a8903d5613fa7359a02e8444a770a07f20"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e67a503cded3f6b9a88562d824be83d91cace7941525ad2e1ff857dc8d5105e"
    sha256 cellar: :any_skip_relocation, ventura:        "75a182e42bee3e4c146ae0fc82053d8c1e86e51916ca36c505f7aa01f64dbfd5"
    sha256 cellar: :any_skip_relocation, monterey:       "46f01fd74f2eb4d274bfe0c01b9c0b928dc15e7ef8be8ac42813ef3e8569faf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7309c342768d0d058c1115a72b123f1a806441452e17308896961a183872b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb29d947930fd06526bd829940a3acd5cad459d9f4005dee6233e35b010f4bc"
  end

  disable! date: "2024-09-09", because: :repo_removed

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/Dreamacro/clash/constant.Version=#{version}"
      -X "github.com/Dreamacro/clash/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:)
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
    system bin/"clash", "-t", "-d", testpath # test config && download Country.mmdb
    client = fork { exec bin/"clash", "-d", testpath }

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
