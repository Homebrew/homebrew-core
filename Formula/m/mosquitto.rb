class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.1.2.tar.gz"
  sha256 "fd905380691ac65ea5a93779e8214941829e3d6e038d5edff9eac5fd74cbed02"
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
    sha256 cellar: :any, arm64_tahoe:   "3d356bb96333aa2fb4e512d4be6df36eec4b6b171be14707e51e16e94d3cb95d"
    sha256 cellar: :any, arm64_sequoia: "bc05eadb0b5387d4dc9c232a2e3b0588c25339c69b6784edf544efea4de0a9ac"
    sha256 cellar: :any, arm64_sonoma:  "1c4d34f060368585fbafc2e1abcc769eb482545b68b0e7996a5c0d99a1c74050"
    sha256 cellar: :any, sonoma:        "ca8649a93eaca061ea9ddfbf3c0b26de1be9cee0acddc0e7043a41fd844aee4d"
    sha256 cellar: :any, arm64_linux:   "fb24ad3850e62be951333db9ed37cf7da0189cac94c2f14807209a42e770f871"
    sha256 cellar: :any, x86_64_linux:  "1e436a8fcaa2ea3f62efa61336195542d9a6d484466be0d9667d6445feab6880"
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
