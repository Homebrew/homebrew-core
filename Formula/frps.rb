class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.29.1",
      :revision => "adc3adc13bf3a2bc43354377b842944f9cfc6a25"

  bottle do
    cellar :any_skip_relocation
    sha256 "512ba0f9e18a0a6a7536bd75c2a2babf2b1a0900764274845b5fcd94709adc99" => :catalina
    sha256 "32068e67028df661ddaef5b4c1eecd1f3e948ee181deb92000766bd86f5738b9" => :mojave
    sha256 "3f8b39694d23845dd51cf183a3fbb159a431eede587bef44c317355579e5ab7a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/fatedier/frp").install contents

    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    cd "src/github.com/fatedier/frp" do
      system "make", "frps"
      bin.install "bin/frps"
      etc.install "conf/frps.ini" => "frp/frps.ini"
      etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "frps -c #{HOMEBREW_PREFIX}/etc/frp/frps.ini"

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
    system bin/"frps", "-v"
    assert_match "Flags", shell_output("#{bin}/frps --help")

    begin
      read, write = IO.pipe
      pid = fork do
        exec bin/"frps", :out => write
      end
      sleep 3

      output = read.gets
      assert_match "frps tcp listen on", output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
