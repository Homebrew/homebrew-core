class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.14.tar.gz"
  sha256 "d0dde8fdb12caf6e2426b4f28081919a2fce3448773bdb8af0d3cd5fe5776925"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "92a59ffbdb47053e77f36675ef075449345dcea7bdc254526405aa31ed2d7a21"
    sha256 arm64_big_sur:  "c40d4a17c9f8a52f326ecef721466e750aa81f273e2e5d98fa6c363de658a0fd"
    sha256 monterey:       "0e314cf5f5a8740ea67a35d6ca060720b4f6d071fdf1343f797a0319ee88cbb2"
    sha256 big_sur:        "c77536fa79291ed18b741733ea4847883e60d53a651a89c034190f066d0eb377"
    sha256 catalina:       "164d07eb54f034a6dbd23d5ad347ead5154cb97741ac3c2e164f3f1d266837c0"
    sha256 x86_64_linux:   "4c2327faf63358dcd1b16d6b759b3c5c8be40a704f3a3532c7d3dfde9991032d"
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
