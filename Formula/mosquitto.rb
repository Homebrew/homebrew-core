class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.5.5.tar.gz"
  sha256 "fcdb47e340864c545146681af7253399cc292e41775afd76400fda5b0d23d668"

  bottle do
    sha256 "d2331f08eb21f953a44a84574f9d849a1eeb583e95740a7a10780c4074a1d767" => :mojave
    sha256 "edb1c861b690b730a45871bf7b631cc7ddf63857d34cd62e76c8e851b8459d5a" => :high_sierra
    sha256 "42448af7684434a1cda382fd36d6c39af8cf043b5a67676daf4f4ab02d177b8b" => :sierra
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
