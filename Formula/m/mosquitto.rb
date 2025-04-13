class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.21.tar.gz"
  sha256 "7ad5e84caeb8d2bb6ed0c04614b2a7042def961af82d87f688ba33db857b899d"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f7f1f3f4762d867f5becdfc8c4a9b3a937794cbc9ea617b62304db97990b034"
    sha256 cellar: :any,                 arm64_sonoma:  "d86b058b1dc26c63f613552aa05a509708ac71296e98df8cb9a56884712685e4"
    sha256 cellar: :any,                 arm64_ventura: "8454c87786ea6c22427a93837a9245f5e11e361e9cf0bbf0dc65b4e606c9df92"
    sha256 cellar: :any,                 sonoma:        "6f3c1be1652b15e940304f6354f8d9dfaee1df2d773d58e6cc9dfb8246d4574d"
    sha256 cellar: :any,                 ventura:       "b48c0a1ca034fc2c958686125ac443db99b66149b0bf50b1fc0ce56d2577661a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c3ed1d516bd691d832028634921690f4b1a64c7ec9a15ab00ccb771d6845a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b8eccb6a949e8194b38e90d7d35c94a7df188058ab656bc9e0d961c5e119978"
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
    assert_match "Usage: mosquitto ", shell_output("#{sbin}/mosquitto -h", 3)
    assert_match "Dynamic Security module", shell_output("#{bin}/mosquitto_ctrl dynsec help")
    system bin/"mosquitto_passwd", "-c", "-b", testpath/"mosquitto.pass", "foo", "bar"
    assert_match(/^foo:/, (testpath/"mosquitto.pass").read)
  end
end
