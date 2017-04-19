require "language/go"

class Kcptun < Formula
  desc "Extremely simple & fast UDP tunnel based on KCP protocol"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20160904.tar.gz"
  sha256 "71a3db97ee88cd010fa5ceaf0f3e3afff5462a907cd1329989a6e139b4db46b0"
  head "https://github.com/xtaci/kcptun.git"

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git"
  end

  go_resource "github.com/xtaci/smux" do
    url "https://github.com/xtaci/smux.git"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git"
  end

  go_resource "github.com/xtaci/kcp-go" do
    url "https://github.com/xtaci/kcp-go.git"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git"
  end

  go_resource "github.com/klauspost/reedsolomon" do
    url "https://github.com/klauspost/reedsolomon.git"
  end

  go_resource "github.com/klauspost/cpuid" do
    url "https://github.com/klauspost/cpuid.git"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/xtaci"
    ln_sf buildpath, buildpath/"src/github.com/xtaci/kcptun"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", "kcptun_client", "github.com/xtaci/kcptun/client"
    bin.install "kcptun_client"

    (buildpath/"kcptun_client.json").write <<-EOS.undent
{
    "localaddr": ":12948",
    "remoteaddr": "vps:29900",
    "key": "ahufr6qedR",
    "crypt": "salsa20",
    "mode": "fast2",
    "conn": 1,
    "autoexpire": 60,
    "mtu": 1350,
    "sndwnd": 128,
    "rcvwnd": 1024,
    "datashard": 70,
    "parityshard": 30,
    "dscp": 46,
    "nocomp": false,
    "acknodelay": false,
    "nodelay": 0,
    "interval": 40,
    "resend": 0,
    "nc": 0,
    "sockbuf": 4194304,
    "keepalive": 10
}
    EOS

    etc.install "kcptun_client.json"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/kcptun/bin/kcptun_client -c #{HOMEBREW_PREFIX}/etc/kcptun_client.json"

  def plist; <<-EOS.undent
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
    assert_match "kcptun version", shell_output("#{bin}/kcptun_client -v")
  end
end
