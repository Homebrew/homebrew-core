class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.12.0.tar.gz"
  sha256 "9b8f28c2adf378e4da5b139dd72c3e13bf19394e2555080832dc47c64fbcdb9a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c7a469c63891a0b9d4818b8d730e6c20b9b0833b5bc031319cb3af9c3a9ff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50119b6629a334add226c3e14a0fe47233e6611d4f246eda0f65121d23bee7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2815f1f99682ff2824ab8e2925767599919dec5d923f3c39452238cea53805f8"
    sha256 cellar: :any_skip_relocation, ventura:        "3dac92d8a86f354787a3f3827d36159f592343b808deacc30d78deafc6e38fba"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d18529a0abf0d08c1eb2ec34b044250ff1c2976a23b670d9101b0b525ab0a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "58df724d6348a90fa8fecd970f25c7880655ef6799bc5ad050d99afe8404fe63"
    sha256 cellar: :any_skip_relocation, catalina:       "ace7d3d3507417747f6c9aeb775982f4da5838cb4159f8e9111cb33593dcd4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8104f11972dc1c533c7febe6ab9ce8dc8dda6f50797a6bc80023c4f21654db62"
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
