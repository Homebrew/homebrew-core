class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.28.2",
      :revision => "134a46c00b59a641dc89ab9265ea73d2d7aa6ff2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa062db1085b9e11ebbdd4baf03ce7bef56d2168c2288423f4ae28f2ea1e8001" => :mojave
    sha256 "31f8e5af275e4ab92edda4626b9de6f353130ccc5659b25a6426005dce67f3d4" => :high_sierra
    sha256 "0eef7db9939953bbc54c10d146f91882a280016addea3b0f65d6a79de05dc809" => :sierra
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
