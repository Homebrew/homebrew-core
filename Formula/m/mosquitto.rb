class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.22.tar.gz"
  sha256 "2f752589ef7db40260b633fbdb536e9a04b446a315138d64a7ff3c14e2de6b68"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c6c83559c4225803fac92c56d4d7b09768a9f128abe52c4eb659cb6ab6a855e"
    sha256 cellar: :any,                 arm64_sonoma:  "3728a4f1c4b8b1f75696ada03cdc23ee0a1e292bf454892a4ac7a1bf76389de6"
    sha256 cellar: :any,                 arm64_ventura: "c88f2922625a60f13586f2ca5e4dd6b524554363d99522bdfb425d6c459469ba"
    sha256 cellar: :any,                 sonoma:        "f9240ee2eae20f16732e4a57615f5d8c8a59931d9e55931d48633297af03984c"
    sha256 cellar: :any,                 ventura:       "59d62a55cd9a1d05cad093eebd1f289ca575ff1067597b0f27932800442348fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c32a19c57963d7038a757528ca7d9ff93f43d913be2058dd111429cad402fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23d5729b9b53d14ad513053e43f1b84cb9d7df805250459c84fddb9c9488b36"
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
    assert_match "Usage: mosquitto ", shell_output("#{sbin}/mosquitto -h")
    assert_match "Dynamic Security module", shell_output("#{bin}/mosquitto_ctrl dynsec help")
    system bin/"mosquitto_passwd", "-c", "-b", testpath/"mosquitto.pass", "foo", "bar"
    assert_match(/^foo:/, (testpath/"mosquitto.pass").read)
  end
end
