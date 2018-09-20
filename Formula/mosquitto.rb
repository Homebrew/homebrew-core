class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.5.2.tar.gz"
  sha256 "7e90ccfe95179cfe6bf7d7f725281dd83041f241a8f093c9d3883b926584de9c"

  bottle do
    sha256 "9f8a48f1841e761956a31628e8aff3ea38524756f7ddf7d916d5a4f340bfc4e4" => :mojave
    sha256 "5bc4c7b72153aeeb107e4af15620ad99b5cc553e35ae77b640fa9c21082a1b7a" => :high_sierra
    sha256 "cf5c2831ebe5680dc875f42864c805dbc8b2d7b5de35f6f7f626f9af09e50953" => :sierra
    sha256 "d746ae9e41a0c61e1dbaddf0eb96215c9587add7a7913d8ec08669ce118ff2f8" => :el_capitan
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
