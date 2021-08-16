class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.3.tar.bz2"
  sha256 "6956433c71dd17a902cd3f4a394ce48a1ea787faed526faf557c95cc434d3e59"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9fe3e880c7dbad11250e2b9c9ec667b9f889acd93b3fcde0b58fbfe67c840e9e"
    sha256 cellar: :any,                 big_sur:       "073696834600548ef1830d0087374bf1321a9b8a9bc3ad6d52551a2d66400c47"
    sha256 cellar: :any,                 catalina:      "bdbf3a4a84b10227f6096ee0afa72dc57fb9b78ece3f6ed09a22bef02b0348cb"
    sha256 cellar: :any,                 mojave:        "f3857ad6c5c1ac83a44d2c590a71f1c0c15dfcf1462763fa59d1225ce6c11d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4910f18bae9e0aec5366e078f199929cd299d6643b9cdcb1819007b40b4d634"
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
