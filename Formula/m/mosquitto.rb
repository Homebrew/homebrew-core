class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.1.4.tar.gz"
  sha256 "ca30b26ccd3041c0e11fc407fe4f2e62bc445e8d8dea94a083cc60c09bd5ea30"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "ae43f095031868aa89960c96c7218c770431728b090e4ff0042cfa3f2fb02fbf"
    sha256 cellar: :any, arm64_golden_gate: "10d1a49e02b3f57afac64a0bee721a4594e65544694aa944e768f4c8f8708917"
    sha256 cellar: :any, arm64_tahoe:       "f19137f77ba9372109fa328d20f834ba5d201f7e27847a8f387b22bf06efac4b"
    sha256 cellar: :any, arm64_sequoia:     "d7e5da6f1a009780178b054678d08e08035b025cede910975ecdddb9f02a34d3"
    sha256 cellar: :any, arm64_linux:       "1b0028ae1c0f2db09976df3a71067af30881f20102272b5c5d4e31c73d36a786"
    sha256 cellar: :any, x86_64_linux:      "3ae135420fbc58426706331bdaaf41b01373061a518cc9712ce5f4d745b20db3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@4"

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
