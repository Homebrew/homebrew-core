class JfrogMissionControl < Formula
  desc "Dashborad for JFrog Products."
  homepage "https://www.jfrog.com/mission-control"
  url "https://dl.bintray.com/jfrog/jfrog-mission-control/jfrog-mission-control-1.5.2.zip"
  sha256 "2f5d5102b86c840067986dd04654c2e5c42eb9442c8d738721b7b99f0711fcf5"

  depends_on :java => "1.8+"
  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Set correct working directory
    inreplace "bin/mission-control.sh",
      'export MC_HOME="$(cd "$(dirname "${MCBINDIR}")" && pwd)"',
      "export MC_HOME=#{libexec}"

    libexec.install Dir["*"]

    # Launch Script
    bin.install_symlink libexec/"bin/mission-control.sh"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mission-control/libexec/bin/mission-control.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.jfrog.mission-control</string>
        <key>WorkingDirectory</key>
        <string>#{libexec}</string>
        <key>Program</key>
        <string>#{bin}/mission-control.sh</string>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match "Checking arguments to Jfrog Mission Control", "Checking arguments to Jfrog Mission Control"
  end
end

