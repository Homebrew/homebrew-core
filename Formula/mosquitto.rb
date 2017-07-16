class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.4.14.tar.gz"
  sha256 "156b1fa731d12baad4b8b22f7b6a8af50ba881fc711b81e9919ec103cf2942d1"

  bottle do
    sha256 "73461d3e6eb0f4c0807f9c60de4e3bea4933b1371cecaf1f9c1ff9b2b223f8ca" => :sierra
    sha256 "6de19142f46f4732d49c4fd3abfbeeefc7c4f0c2e5e087b8a182604e2da6788d" => :el_capitan
    sha256 "aac7e391c200465aa7783d9b65db27e79f686db6d5dd9e22e13859204f26cff9" => :yosemite
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
