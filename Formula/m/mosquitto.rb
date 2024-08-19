class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.18.tar.gz"
  sha256 "d665fe7d0032881b1371a47f34169ee4edab67903b2cd2b4c083822823f4448a"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ed6fa66f74bb88539a0ed66d32ebf20d58d099ab6fc2131703d2cb6c26f053e1"
    sha256 arm64_ventura:  "f7946b65c41657ea97975c9ce2a2d1e2c63f6dd2f55a5ad048fe9afdbff00d29"
    sha256 arm64_monterey: "96990068f0968e20dbef5b553804855046bc332e66a144f792e0a668a383ce38"
    sha256 sonoma:         "30e0c34d24332a35286dcf4737a9715370a3d62ff501fb47412ef755f72ec3a8"
    sha256 ventura:        "be22defe47ce61833d400523b75ca6a4d8a67ccc3c56bae5114f8f3290df3f90"
    sha256 monterey:       "4702e5a0ca4da921a85b8970f0dd9e6ed64788522f483b66fd025cd281d2ceea"
    sha256 x86_64_linux:   "d699f5436ec14373d7c83e6ec811c2ac5ffef9595db2c48df8bbb20f1e975ae2"
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
    quiet_system sbin/"mosquitto", "-h"
    assert_equal 3, $CHILD_STATUS.exitstatus
    quiet_system bin/"mosquitto_ctrl", "dynsec", "help"
    assert_equal 0, $CHILD_STATUS.exitstatus
    quiet_system bin/"mosquitto_passwd", "-c", "-b", "/tmp/mosquitto.pass", "foo", "bar"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
