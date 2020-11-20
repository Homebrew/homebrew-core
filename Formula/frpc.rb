class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.34.3",
      revision: "aa0a41ee4e3fd332978d509dcdbb09a7f457c880"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1103b60f3dad614381303421335b8aea3a0b5250fdb1b5344c49dc73e3888000" => :big_sur
    sha256 "28ad23b5827f4de1ed71dad560e52adef862f6489c4beef93cb823d019508656" => :catalina
    sha256 "e752b532e81df470bdbbda250110f258c73402f5d5eb5161d34128505ce0fcfe" => :mojave
    sha256 "7116324b360e885089aac9954337f6e4a434ee4c9673ce8dd3227ff4b217dda1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.ini" => "frp/frpc.ini"
    etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
  end

  plist_options manual: "frpc -c #{HOMEBREW_PREFIX}/etc/frp/frpc.ini"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/frpc</string>
            <string>-c</string>
            <string>#{etc}/frp/frpc.ini</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/frpc.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/frpc.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "local_port", shell_output("#{bin}/frpc http", 1)
    assert_match "local_port", shell_output("#{bin}/frpc https", 1)
    assert_match "local_port", shell_output("#{bin}/frpc stcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc tcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc udp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc xtcp", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc status -c #{etc}/frp/frpc.ini", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc reload -c #{etc}/frp/frpc.ini", 1)
  end
end
