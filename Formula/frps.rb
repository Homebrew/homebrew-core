class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.33.0",
      :revision => "2406ecdfea62567a576bdb71e38adbafa3b4814a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1f2f28f18b53ca6041b7e3b55156a26c131fe1c163a1a559ffa158836ab75af" => :catalina
    sha256 "dfc09d5fb82cdb397f955ef6bc2ba9f2d7fa7b5f00cf2aae5ed7bd427f3f7fa6" => :mojave
    sha256 "de264b527c16414a7ae39b8334c953b8d9464c27b8b1c4f1ffc8300f35d3e0af" => :high_sierra
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  plist_options :manual => "frps -c #{HOMEBREW_PREFIX}/etc/frp/frps.ini"

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
            <string>#{opt_bin}/frps</string>
            <string>-c</string>
            <string>#{etc}/frp/frps.ini</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/frps.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/frps.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", :out => write
    end
    sleep 3

    output = read.gets
    assert_match "frps tcp listen on", output
  end
end
