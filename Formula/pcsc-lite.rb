class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.1.tar.bz2"
  sha256 "73c4789b7876a833a70f493cda21655dfe85689d9b7e29701c243276e55e683a"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "41493aaf4724a8d9dcdc0d201adfb0ff106f0fda64cd0c61cb2a7a6cadfda542"
    sha256 cellar: :any, big_sur:       "738ed819f64c346f2761678b8ca2e39eb9043d92d6d4fd365f6b0650097e225a"
    sha256 cellar: :any, catalina:      "a4da98096949c1944ed1754fb4d34eb65573c88b86c0d24401f783459e1240e9"
    sha256 cellar: :any, mojave:        "46aee062069037df86dc1064a2cdced328a21dce899bc15429ffe2b6151dacf3"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]

    on_linux do
      args << "--disable-udev"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
