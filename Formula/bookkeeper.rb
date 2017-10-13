class Bookkeeper < Formula
  desc "Replicated log service for building replicated state machines"
  homepage "https://bookkeeper.apache.org/"
  url "https://apache.claz.org/bookkeeper/bookkeeper-4.5.0/bookkeeper-server-4.5.0-bin.tar.gz"
  sha256 "757abd3083291cb28d6a40342ac6e34b3b802ecc36ba5487a08df92bccc9768e"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/bookkeeper"]
  end

  plist_options :manual => "bookeeper localbookie 4"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bookkeeper</string>
          <string>localbookie</string>
          <string>4</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/bookkeeper.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/bookkeeper.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match "Usage: bookkeeper", shell_output("#{bin}/bookkeeper help")
    begin
      pid = fork do
        exec "#{bin}/bookkeeper localbookie 1 &> test.log"
      end
      sleep 5
    ensure
      Process.kill(9, -Process.getpgid(pid))
      Process.kill(9, pid)
      Process.wait(pid)
    end
      dat = File.read(Dir["*.log"].first)
      assert_match "Starting Bookie(s)", dat
  end
end
