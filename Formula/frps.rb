class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.28.2",
      :revision => "134a46c00b59a641dc89ab9265ea73d2d7aa6ff2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1745ad660f51eb5b93da7b5e3ed7330f31ecb996c7250be727ee2dfe79500186" => :mojave
    sha256 "96668d2dbda092d4160bf39219cb873856cf3d55577e7b611fc93cd6d10a5f6a" => :high_sierra
    sha256 "9de5e472aafdeab140ee687e8c1e130ffd8a8d3b17a348adb3d15610e2bdfc5d" => :sierra
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
