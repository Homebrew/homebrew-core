class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.22.tar.gz"
  sha256 "2f752589ef7db40260b633fbdb536e9a04b446a315138d64a7ff3c14e2de6b68"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]
  revision 1

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8467e8dcbd98798e7d7e9ad55d59a0fd4cc55fff200c6ed05bf37f85988e8aab"
    sha256 cellar: :any,                 arm64_sequoia: "e527efed4ff5fc3451a6c2e06a8104a2963818e19e309102f3180e61788cca14"
    sha256 cellar: :any,                 arm64_sonoma:  "799c04a8715717c7ffb8afa05a0d9f883dcb10b7974a007867fd16490225375e"
    sha256 cellar: :any,                 sonoma:        "551d0141173d6a4871fdf3992d2d06b21f8e538a51c525518ae26ea1decc7c11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379189844ea932eec2348770028c5fa7d45a9879723bc01556ef775c050f9393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba022e0965b028e4da39194e492c9ca03a99a1e49ae9ccce08547133dc634c8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_PLUGINS=OFF
      -DWITH_WEBSOCKETS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    assert_match "Usage: mosquitto ", shell_output("#{sbin}/mosquitto -h")
    assert_match "Dynamic Security module", shell_output("#{bin}/mosquitto_ctrl dynsec help")
    system bin/"mosquitto_passwd", "-c", "-b", testpath/"mosquitto.pass", "foo", "bar"
    assert_match(/^foo:/, (testpath/"mosquitto.pass").read)
  end
end
