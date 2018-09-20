class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.5.2.tar.gz"
  sha256 "7e90ccfe95179cfe6bf7d7f725281dd83041f241a8f093c9d3883b926584de9c"

  bottle do
    sha256 "c79522eea6110ddea1497cf252c2f1991107cfafa114f5280f3cf787cd2cf884" => :mojave
    sha256 "b7f54c6f51a798b11d33bde6fe7a927aba784de317a1abc0e6e0ff0ef2d9f2c6" => :high_sierra
    sha256 "67afe32dcd96e598b112b1b26cec5f0725f6db8e2e898644c197594bb7fef020" => :sierra
    sha256 "0d984daefe7158e3c049d100f80327789425cb15dc2ca86b64134fb42befd9a6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_WEBSOCKETS=ON"
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats; <<~EOS
    mosquitto has been installed with a default configuration file.
    You can make changes to the configuration by editing:
        #{etc}/mosquitto/mosquitto.conf
  EOS
  end

  plist_options :manual => "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/mosquitto</string>
        <string>-c</string>
        <string>#{etc}/mosquitto/mosquitto.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{var}/mosquitto</string>
    </dict>
    </plist>
  EOS
  end

  test do
    quiet_system "#{sbin}/mosquitto", "-h"
    assert_equal 3, $CHILD_STATUS.exitstatus
  end
end
