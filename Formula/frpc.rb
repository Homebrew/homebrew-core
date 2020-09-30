class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.34.1",
      revision: "e0c45a1aca2bf8e2a081d4a40bbbe2585c4134be"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cf1aed923aaf6b17ae068337048c437ac6783cd71c4ffc55366aeb9f7eecae9" => :catalina
    sha256 "901316c75c9c10da95d4b7bcffe5d01048b2474d6d29cd1ded6b3e956ca977a6" => :mojave
    sha256 "129c4d9fefb2216b1b990c650c28ab508a90183bf474afc2511e790f19db9db3" => :high_sierra
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
