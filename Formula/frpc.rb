class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.28.2",
      :revision => "134a46c00b59a641dc89ab9265ea73d2d7aa6ff2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e9672d935e1de69d03f375c2a1ba60b76d3123db77d15baf71a4630a05bab9c" => :mojave
    sha256 "5394a93db3dec5fded0021719900bc7222c08e16a4d09e26ee11b7e36384a198" => :high_sierra
    sha256 "23a81e2b560d2fcfbe86ad3398f9e70ceac12009b5c0cc7483774b9fa6143998" => :sierra
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
