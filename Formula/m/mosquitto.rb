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
    sha256 cellar: :any,                 arm64_tahoe:   "abff8ebca977a7a2112d3b3da4591a51278f6d9d87a4357166b3795a2bbf6c72"
    sha256 cellar: :any,                 arm64_sequoia: "b104d46d1e87f19a87dde8f703a88f96cfd8a7b14f5c890cc80f1d4e87d00d5e"
    sha256 cellar: :any,                 arm64_sonoma:  "a698100e3f6c3ad8c4d12be8d53172fa945cdf90e07e98a8f17e3312c18a8a60"
    sha256 cellar: :any,                 arm64_ventura: "713166fcd44dc4ab41c7ee26c7568657d1ed85f70a561bcb29db93a21c5aaa2d"
    sha256 cellar: :any,                 sonoma:        "d1d3912c6cce5c515067a154b4b624215b596657ae004d774035fe589915b775"
    sha256 cellar: :any,                 ventura:       "773f0dbebde7df42a048ce1a5d14dec13773f633bbd660b89d66e78325501ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3cf5fd9fdbcd233b9cf42df8604833d65d84b6173e27a997abdf64fe9ca883d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e2773ad764574334ea17d44e074dcb4106d9549d6efe7eca8ea600fdefab4e"
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
