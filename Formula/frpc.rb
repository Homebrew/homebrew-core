class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.26.0",
      :revision => "6a7efc81c9fcd410ba603573cdbe501056b1b04a"

  bottle do
    cellar :any_skip_relocation
    sha256 "13fdfb091388d4288eb19289dbfc45f09e7a21a94cece0e8d669e80b9c4f94d7" => :mojave
    sha256 "a64f8f155f54a6a13d3d8b8e91c4d47d97e4c244f1878678bae671f81f19693d" => :high_sierra
    sha256 "c963d12a7685b1d747a164eb9f50e376c1397809931f579b35b1adb82b97754a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/fatedier/frp").install contents

    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    cd "src/github.com/fatedier/frp" do
      system "make", "frpc"
      bin.install "bin/frpc"
      etc.install "conf/frpc.ini" => "frp/frpc.ini"
      etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "frpc -c #{HOMEBREW_PREFIX}/etc/frp/frpc.ini"

  def plist; <<~EOS
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
    system bin/"frpc", "-v"
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
