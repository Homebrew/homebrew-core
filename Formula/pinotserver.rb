class Pinotserver < Formula
  desc "Server component for Apache Pinot"
  homepage "https://pinot.apache.org/"
  url "https://downloads.apache.org/pinot/apache-pinot-0.9.3/apache-pinot-0.9.3-bin.tar.gz"
  sha256 "c253eb9ce93f11f368498229282846588f478cb6e0359e24167b13e97417c025"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/pinot.git", branch: "release-0.9.3"

  depends_on "libtool" => :build

  depends_on "openjdk"
  depends_on "pinotbase"
  depends_on "zookeeper"

  def default_pinot_env
    <<~EOS
      [ -z "$JAVA_OPTS" ] && export JAVA_OPTS="-Xms4G -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xloggc:gc-pinot-broker.log -Dlog4j2.configurationFile=/usr/local/etc/pinotserver/log4j2.xml"
    EOS
  end

  def install
    mv "conf", "pinot-server"
    etc.install "pinot-server"
    libexec.install_symlink etc/"pinot-server" => "conf"
  end

  plist_options manual: "pinot-admin StartServer"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
             <key>JAVA_OPTS</key>
             <string>-Xms4G -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xloggc:gc-pinot-controller.log -Dlog4j2.configurationFile=/usr/local/etc/pinot/log4j2.xml</string>
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
            <string>/usr/local/bin/pinot-admin</string>
            <string>StartServer</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match(/StartServer/, shell_output("#{bin}/pinot-admin -h 2>&1"))
  end
end
