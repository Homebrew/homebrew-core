class Bookkeeper < Formula
  desc "Rplicated log service for building replicated state machines"
  homepage "https://bookkeeper.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=bookkeeper/bookkeeper-4.4.0/bookkeeper-server-4.4.0-bin.tar.gz"
    sha256 "2ec1f34ae1f0be4ee54a9d986bbc7ff75bed831a0b47ec8e1cd90c82afe02951"
  end

  depends_on :java => :recommended

  def install
    libexec.install Dir["bin/*", "CHANGES.txt", "LICENSE", "NOTICE", "README"]
    prefix.install Dir["conf", "*.jar", "lib/*"]
    bin.install_symlink libexec/"bookkeeper"

    inreplace libexec/"bookkeeper" do |s|
      s.gsub! /^BINDIR=.*$/, "BINDIR=#{bin}"
      s.gsub! /^BK_HOME=.*$/, "BK_HOME=#{prefix}"
      s.gsub! "$BK_HOME/lib", "$BK_HOME"
    end

    # bin.mkpath
    # (etc/"zookeeper").mkpath
    # (var/"log/zookeeper").mkpath
    # (var/"run/zookeeper/data").mkpath
  end

  def caveats; <<-EOS.undent
    You need to initialize zookeper before running bookkeeper. Use the command:
      bookkeeper shell metaformat

    You may also want to set the JAVA_HOME environment to a suitable value.
    EOS
  end

  plist_options :manual => "bookkeeper start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
           <key>SERVER_JVMFLAGS</key>
           <string>-Dapple.awt.UIElement=true</string>
        </dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bookkeeper</string>
          <string>bookie</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end
end
