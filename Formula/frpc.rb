class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.35.0",
      revision: "b2ae433e18fcecaa752df49806c2d230570a5900"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "16c2574a266ba143cfb8a21c1a861c7cdf72fee01bba872e8ad791bdb79c26d9" => :big_sur
    sha256 "50cab3b1f46d6e7b4224d6f9e4bd0b7d18e3445fc260d40729e08ccfa282ff81" => :arm64_big_sur
    sha256 "cbb573268565ade29a95e20f458678ffe2182367603e4640ed8cec12ff3b9285" => :catalina
    sha256 "8781e241ebe52fad10c329292cdd4cb12438ac74f45348c7e3d398e3ad573578" => :mojave
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
