class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.17.tar.gz"
  sha256 "3be7a911236567c1a9fbe25baf3e3167004ba4a0c151a448ef1f7fc077dba52f"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "151d4602be94b6c9afba945e1bf1e1b00b583a44e7f524754412ba668205c9e9"
    sha256 arm64_monterey: "e1f7833a29d520667233f8f1520ed93efa16f5203aa2ba41983390d6914b5542"
    sha256 arm64_big_sur:  "626ac57a2ee05bf77b60d04abd5675ca4a99f61b826d83e4365f17841615598b"
    sha256 ventura:        "b06442f194bf0597cd50f2e4c87e719b4ab53c34b02a810343f05b1eec02f757"
    sha256 monterey:       "6d5d948e77f84c99e3a83b4709e766849693f09fa05da8810bec5fab885ced59"
    sha256 big_sur:        "a94e32e4a0c3ff0c06dc0f07b9f0cc3e8e3a236d9f4e56669a06b3bfe9cea05b"
    sha256 x86_64_linux:   "c8f88d6c08fa5840601730e1244ba0ce0db627cfa1606c30daf9afad29bf7803"
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
