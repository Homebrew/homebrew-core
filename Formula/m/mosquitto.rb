class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.1.2.tar.gz"
  sha256 "fd905380691ac65ea5a93779e8214941829e3d6e038d5edff9eac5fd74cbed02"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd40843dd4c3abf5f5d2ad89f221fc02439a354857e808d7f9b243f8f39f4671"
    sha256 cellar: :any,                 arm64_sequoia: "b74d967ddee4b766879377d5105dc7a6d696439a71e7dbb2d81034ce70601336"
    sha256 cellar: :any,                 arm64_sonoma:  "175bc6e9e6dbfa0b16beeb2c17332db6393fb46c483e4de9d77e54365ceed255"
    sha256 cellar: :any,                 sonoma:        "ae293e339a16b9f4fe4088a560fc7eda47078030948be656c913d2a19e3270f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfac26df2cee898d81613a7dc486b15d5e00a95470a628b7482b76ffa0a8bec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160ad334e165168957eb3adf047fa8fe6e040157920f9c457afbcd44d3b73e82"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_PLUGINS=ON
      -DWITH_WEBSOCKETS=ON
      -DWITH_TESTS=OFF
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
