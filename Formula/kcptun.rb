class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20210103.tar.gz"
  sha256 "0821b61b92041b764a1d621f750c1c693d913eed43051d3c109bd303d8f02472"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc75f03bc0f50c583a5e0f96213676e497488f1874d957807d894ca046ddda3a" => :big_sur
    sha256 "8ab8b8114de4af975ace979ee4baefb67b7ae04b0895d0863993f08dc574f193" => :arm64_big_sur
    sha256 "003ec31729751a51c32c13c44d8dcc255550d300d38a9267167b8e9455a79212" => :catalina
    sha256 "dbc0ec286493d29d1df9c9c7bde3290339efa894bed73474caad58926e58c717" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_client", "github.com/xtaci/kcptun/client"
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_server", "github.com/xtaci/kcptun/server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/kcptun/bin/kcptun_client -c #{HOMEBREW_PREFIX}/etc/kcptun_client.json"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/kcptun_client</string>
            <string>-c</string>
            <string>#{etc}/kcptun_client.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kcptun.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kcptun.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
