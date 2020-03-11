class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      :tag      => "v0.32.0",
      :revision => "ea62bc5a3448e574618f45d7f764e3c09465f81f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2886241566239b457a5a0f83b72c88a019aa6a6b9ad25739020c24da6e147655" => :catalina
    sha256 "b76d9deb404f9542581cb4ed0a3ecce9996663513be80b762ee117c558082f98" => :mojave
    sha256 "888aebaeaec87eaacc2ebebe6578df398af42a51cd79cd42444d0a87a3697615" => :high_sierra
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
