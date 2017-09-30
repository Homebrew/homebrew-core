class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.4.14.tar.gz"
  sha256 "156b1fa731d12baad4b8b22f7b6a8af50ba881fc711b81e9919ec103cf2942d1"
  revision 1

  bottle do
    sha256 "7ea0a7982a2d47760203fe11841f3ba4a66bc0f8521836d24de79dbf6aeb21c9" => :high_sierra
    sha256 "01ff6c3a66361786dc44681b57dcc7990298a9b316768025fa131398a8eca51c" => :sierra
    sha256 "4533adf7814abcccdf7cb7a0833f1c0b6208d0eb5137ed71fe9c7a18a8803857" => :el_capitan
    sha256 "747266868ed02a667fe56f04ed6df028eb893e8dc5227b4e859a6c50ff6188e6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "libwebsockets" => :recommended

  def install
    args = std_cmake_args
    args << "-DWITH_WEBSOCKETS=ON" if build.with? "libwebsockets"

    system "cmake", ".", *args
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats; <<-EOS.undent
    mosquitto has been installed with a default configuration file.
    You can make changes to the configuration by editing:
        #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  plist_options :manual => "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

  def plist; <<-EOS.undent
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
