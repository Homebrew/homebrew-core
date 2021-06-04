class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.10.tar.gz"
  sha256 "0188f7b21b91d6d80e992b8d6116ba851468b3bd154030e8a003ed28fb6f4a44"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"
  revision 1

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "37075e4522029d3c29a0f5f01a2765e21d7d7861b916fbc411c18aabb5eecc1d"
    sha256 big_sur:       "b4d048a8ae02ea81048315280fdca94beb5c36f9cbf2fc5e7d572147a1d9056f"
    sha256 catalina:      "3e75e7bf3ff9c1e75b55ceb0558341e5105714552498252a74bbfabf061c5b83"
    sha256 mojave:        "12ea925ba276e00955710d333279aa06ecfe0038a37a9ce7c9d4ad64bb628a96"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DWITH_WEBSOCKETS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
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

  plist_options manual: "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

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
    quiet_system "#{bin}/mosquitto_ctrl", "dynsec", "help"
    assert_equal 0, $CHILD_STATUS.exitstatus
    quiet_system "#{bin}/mosquitto_passwd", "-c", "-b", "/tmp/mosquitto.pass", "foo", "bar"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
