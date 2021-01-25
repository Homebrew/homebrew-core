class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.16.1/apache-activemq-5.16.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.16.1/apache-activemq-5.16.1-bin.tar.gz"
  sha256 "43d3f3a890bffae85c6f1002e9cf950fcc1fd17f3f5e55dc3b85d39d09e2e323"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    on_macos do
      rm_rf Dir["bin/linux-x86-*"]
    end
    libexec.install Dir["*"]
    (bin/"activemq").write_env_script libexec/"bin/activemq", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  plist_options manual: "activemq start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>AbandonProcessGroup</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{opt_libexec}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/activemq</string>
            <string>start</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
