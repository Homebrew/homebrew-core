class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.16.tar.gz"
  sha256 "638db9e43e89d243ea98d10d66e76ff376131217780decd01abaffacc66d8035"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "80b65d020c420302300986dfe0c617d298a8548b457f7f02c8d51f92cda0a0af"
    sha256 arm64_monterey: "0e698aaa31de0269cfed65d37218ed0e90bec67484a8a3ba23e98b862ac09b51"
    sha256 arm64_big_sur:  "73397563769ae4d1971c03a12d201ebe14cbc577dcfc8696538b566b0de00cb0"
    sha256 ventura:        "8ee95d43a3bedcc11ac820946c1725ccfb07e0646ca02b2a20c63f07e431dab3"
    sha256 monterey:       "356b5a180dad384498883c5fdbabb65da91204eee6d5568a33d8b236a1f8e7db"
    sha256 big_sur:        "a61ac1bd1c5c25222a2f67e3fa3455712c3c6f966debf0ede85fe82faf9e4936"
    sha256 x86_64_linux:   "01151bd16cc3f3ff54ca08bd0fdacb74acbdbbc5e7742a1d49ec06ce55719363"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DWITH_PLUGINS=OFF",
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

  service do
    run [opt_sbin/"mosquitto", "-c", etc/"mosquitto/mosquitto.conf"]
    keep_alive false
    working_dir var/"mosquitto"
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
