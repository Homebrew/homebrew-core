class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.6.9.tar.gz"
  sha256 "412979b2db0a0020bd02fa64f0a0de9e7000b84462586e32b67f29bb1f6c1685"

  bottle do
    cellar :any
    sha256 "fcbdbcbd2f8abdb5880c6468a0c840a3c058d0b743c1200cd70c17d3e84d1271" => :catalina
    sha256 "2c18ef97e5ce7f83a2a7227ce9acf53381ec83ef5321ca78d6e58e377ef5d940" => :mojave
    sha256 "a7c9b071b2961adb291a217b13d21d286defa28d067798865dd2fd3ba5973909" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_WEBSOCKETS=ON",
      "-DWITH_BUNDLED_DEPS=ON"
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  plist_options :manual => "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

  def plist
    <<~EOS
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
