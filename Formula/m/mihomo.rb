class Mihomo < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/MetaCubeX/mihomo"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "0c6f2c073189211aaa5a6ce8019f1c3f421bc4cdc1e46217a0a76912c6a38927"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run opt_bin/"mihomo"
    keep_alive true
    error_log_path var/"log/mihomo.log"
    log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    server_port = free_port
    (testpath/"server/config.yaml").write <<~EOS
      mode: direct
      listeners:
      - name: ss
        type: shadowsocks
        port: #{server_port}
        listen: 127.0.0.1
        cipher: chacha20-ietf-poly1305
        password: test
    EOS
    system "#{bin}/mihomo", "-t", "-d", testpath/"server" # test server config && download Country.mmdb
    server = fork { exec "#{bin}/mihomo", "-d", testpath/"server" }

    client_port = free_port
    (testpath/"client/config.yaml").write <<~EOS
      mixed-port: #{client_port}
      mode: global
      proxies:
        - name: ss
          type: ss
          server: 127.0.0.1
          port: #{server_port}
          password: "test"
          cipher: chacha20-ietf-poly1305
    EOS
    system "#{bin}/mihomo", "-t", "-d", testpath/"client" # test client config && download Country.mmdb
    client = fork { exec "#{bin}/mihomo", "-d", testpath/"client" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{client_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
