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
    rebuild 1
    sha256 arm64_monterey: "7724c1c4493bf3382bc19f4c90bfad2d3c5d73e2a6671f75c66a4f2c81ffe4e6"
    sha256 arm64_big_sur:  "1b42d8e6682597d9f1fcafd98865073266ed116d753f6c6dfc7ec0734b98dcab"
    sha256 monterey:       "aaf7696ee444139c1436fdb00a9463810e4b614a140dec8f2ad790658a4e004e"
    sha256 big_sur:        "41ddee2a82f929b1754686d38f0e67570b1728eee8000ab4d4f68f52b052d152"
    sha256 catalina:       "1459490520f73a2a331487b1fef6163957ed7e4b91868d4bb830ed8448cf7a4b"
    sha256 mojave:         "1c2764711220dba026af2d78c32d3f077da354252be4177059f5816faf610153"
    sha256 x86_64_linux:   "cd02e8539023e928475cf757b1865be0c65961bc55ce16c0006490e521dfb0b8"
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
