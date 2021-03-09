class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.8.tar.gz"
  sha256 "b15da8fc4edcb91d554e1259e220ea0173ef639ceaa4b465e06feb7e125b84bf"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ef77fabb6afa21afc71d4da3702909d62730bf985eab97c50baceab9db726b7d"
    sha256 big_sur:       "77cc5148716a9ae22d6a5b19f92beef6d33cd777c020f2444200368097699b71"
    sha256 catalina:      "0b450c6694c6940368bf150693dbc2e04f3bbda608c691f91fa84509d26d2510"
    sha256 mojave:        "fb1679f4855964d8ed60af4f42903aad617550c9ada5c0e8e3a31c2aa204f2df"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DWITH_WEBSOCKETS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{lib}"
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
  end
end
