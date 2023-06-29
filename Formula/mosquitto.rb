class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.15.tar.gz"
  sha256 "4735b1d32e3f91c7a8896741d88a3022e89730a1ee897946decfa0df27039ac6"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"
  revision 1

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "11d453a758710e8bab026178dacce23bf9585df446beba8ad130159a5bbefc6c"
    sha256 arm64_monterey: "6c04405cb9719bc16b60fc10aac9ae3aa4394cea6a3e59f06b1f5999b66f4909"
    sha256 arm64_big_sur:  "1eca680ea93f7023cb3b94a906bbc612536a57810021ea5e27ee60a178a8f07d"
    sha256 ventura:        "42ce86124cf4eca533db7615e47fb568392d3078af9a6efbda3e2883b193d93e"
    sha256 monterey:       "9d996c8555a24dbda8786a9d094142a7f245aa7e6563c26e50c6b757be8cd396"
    sha256 big_sur:        "1baedd5c20794771215a66f5708038a495d724ce8192ffe8fbdaf56bf64c3119"
    sha256 x86_64_linux:   "ce4e52637ec2ec0fe38afa6388375fba7122a788e6433f039c7354c047bd72e7"
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
