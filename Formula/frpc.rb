class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.28.0",
      :revision => "6451583e60184a90c274f6683a44e89fb7a9118e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a2dbdf194183d1162037c303b5ff96f24208cd1bf0bc469fb56307727e6653e" => :mojave
    sha256 "d59c414fb8b072d0891543ba203d4df619b2a5614b362d6d1cc6ca28c5f86340" => :high_sierra
    sha256 "e36b6b3fc1e9cf00e97a73d6506bedbe25d1a897c0cac471992d32a0e5f3bae6" => :sierra
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
