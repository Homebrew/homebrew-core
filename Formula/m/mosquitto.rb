class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.22.tar.gz"
  sha256 "2f752589ef7db40260b633fbdb536e9a04b446a315138d64a7ff3c14e2de6b68"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]
  revision 2

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b023abe1f25dd18b5e857732e11e2b12afb2353befcc3c7153e58f5db96cfaa"
    sha256 cellar: :any,                 arm64_sequoia: "40f09c55001864b2ca2b15c06f5308a8a37d09890f6734f2dd42a36acad148cf"
    sha256 cellar: :any,                 arm64_sonoma:  "e704eb1b55caf9ffab7c068f010720fc7e0d9d58f1f8cd1197f4686c526ddf82"
    sha256 cellar: :any,                 sonoma:        "8c33134f6ca7f83fc79f8cf9603a0ac8ff0d2d70a49e839c74e260c97cbc1a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71995da1487a33b1d2748d34bb89644f650abf23a7caa3c7c279c4a4f551a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa96cd2a2940b2a0d33470927a513a40bbb04603e5a87648505b966b604b96f"
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
