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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "675c3115d192817ed3e8581991ec8b550f0ca88ba3509d99a76d8030b2220014"
    sha256 cellar: :any, arm64_sequoia: "0e3b6e88355b17ee6b3ba9fe2c49998dd9fefe45d89419ce2a4561c36ddd4e86"
    sha256 cellar: :any, arm64_sonoma:  "42015e87839e23880b3256658549851747ded188645d81ca91cbb047390eeb9d"
    sha256 cellar: :any, sonoma:        "79c0b0e9ab76295bb4cfbadfc32da88a680950b854d38023cb2dbc1b983e4813"
    sha256 cellar: :any, arm64_linux:   "6c4103f1b093feecfc4659a001cd4662cf7b548f904363ade5d67ffff3509a67"
    sha256 cellar: :any, x86_64_linux:  "a8725b3326e97d9a4f99f8cc38f13f741004baefaa90772655d10730381f2b0d"
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
