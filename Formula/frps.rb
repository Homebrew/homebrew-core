class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.31.1",
      :revision => "f480160e2d22b9bbca2590660b50d69a1c5059bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "48fe9cfff7c55e20f58ce65894a853e77cef37be8edde8a0ce5f1ab7ace96b17" => :catalina
    sha256 "556c3fff583e1a5e349b0e00d26dea3bdfc203cac9d1369655bdd5f97390cc68" => :mojave
    sha256 "52766ec337b68162874a0e71949b85e114be9b45f0db861a8d97d684f6ffb699" => :high_sierra
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
