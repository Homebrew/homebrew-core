class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.2.3.tar.xz"
  sha256 "cab1e62755713f62ce1b567954dbb0e9a7e668ffbc3bbad3ce85c53f8f4e00a4"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "760f0716aded7ee6623d5a4108b2e8d6dc87ca8730a28cf93d3ea6817c619ecc"
    sha256 cellar: :any, arm64_ventura:  "5dfea6504f19e8069d37f99ba5348435576868af1bec9c3dea095b498ee1025a"
    sha256 cellar: :any, arm64_monterey: "0b8f14f08afe6d3ce4cd703b00286429da1e2def6232f3aa59e3677a16b9a42e"
    sha256 cellar: :any, sonoma:         "03a78c628d6e82a8da03591d6ea58a93d96d3c28cece699630796941ff3e859e"
    sha256 cellar: :any, ventura:        "6d887b6eccd1b5807864c497ac84c2971381924c1898cfa42ce786698014db2b"
    sha256 cellar: :any, monterey:       "8e0e52ca0fdc9ec478940e3dfe8bce1c9e8656819e54de4bb75d3fa1fe3978ed"
    sha256               x86_64_linux:   "2468288b18f882ed8eed4ab3a8dd5f86c0c8a4208c94e4c39d79218a6de6fb80"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    args = %W[
      -Dlibsystemd=false
      -Dlibudev=false
      -Dpolkit=false
      -Dipcdir=#{var}/run
      -Dsysconfdir=#{etc}
      -Dsbindir=#{sbin}
    ]

    args << "-Dlibudev=false" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
