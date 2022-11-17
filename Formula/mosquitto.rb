class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.15.tar.gz"
  sha256 "4735b1d32e3f91c7a8896741d88a3022e89730a1ee897946decfa0df27039ac6"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "55a97afb21986bd6c3f13d07678278f6f7defe63b660eca4161e84045b4c9c08"
    sha256 arm64_monterey: "f14f8cc7ed101e7422f0f9d24e79d18061bf71e28fbdb85d30bb3b7fcc3e8ab8"
    sha256 arm64_big_sur:  "e650529e5ae101a0d9f27535b1fcdc9fc8987b53b59e6e9589062b36e17212b7"
    sha256 ventura:        "8ac3eac2e01fed16625456843f6269839abce545a7055289d401b25723f96f11"
    sha256 monterey:       "3d0a5aef85420aae906b0b0eb5c112c27af783c87d80a51ccdddfeeaa4daf386"
    sha256 big_sur:        "530901fe4e49c78bdb19b515044bf42b3347a6b4a51306a39c797fa43a2304dc"
    sha256 catalina:       "ce1a1c006b2b83759fd5537d9300d4ffd30d4e2b379e26af94c26594bbafa9b1"
    sha256 x86_64_linux:   "11d51e10b009e0d087595a15e69896778c17634d91b5f3de97ab6862ef5c791b"
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
