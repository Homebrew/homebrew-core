class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20210624.tar.gz"
  sha256 "3f39eb2e6ee597751888b710afc83147b429c232591e91bc97565b32895f33a8"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e345408ba16132ad0013c13015df96fc97fdf4661e67d4f0fc01c574a203097"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cd2c509194e43eafd7b14cb3374e2b96b2438f0c8430aea762915fcfc1d5971"
    sha256 cellar: :any_skip_relocation, catalina:      "cd5687433da66043168a885f2ce895232fa7e44564a4ac73ae2875eaf1310fa2"
    sha256 cellar: :any_skip_relocation, mojave:        "19f310dd4027105d9dc76a526571f9e286c1d77f530de3012a9130daf3f806d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bdeb84abc3711e8d8bb158a38852cb5bb4207323161e97e1c1035fac0fe3d2"
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
