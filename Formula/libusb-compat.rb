class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.8/libusb-compat-0.1.8.tar.bz2"
  sha256 "698c76484f3dec1e0175067cbd1556c3021e94e7f2313ae3ea6a66d900e00827"
  license all_of: [
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"], # libusb/usb.h
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/libusb-compat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f166717b7947442be0d3dd9f4f32af5a81dc1b88e33c1e6d255f3661f1c9b00c"
    sha256 cellar: :any,                 arm64_monterey: "c7806ae398c6e4c21b74591f3963c3dab1daaf789024320e53e26f05cc1969a9"
    sha256 cellar: :any,                 arm64_big_sur:  "8d270d3af266fc64cded433bcd66737e4333be532971ecb7c6fff3013325242f"
    sha256 cellar: :any,                 ventura:        "e9c27a0e5e8079dba3b1c2ebac987650eb104ede405a4ed8eed721a75c66c281"
    sha256 cellar: :any,                 monterey:       "ef60733dc1a9cdd8b90ae397066bcabd3b5afa0cc156593282f827d7dfb62af0"
    sha256 cellar: :any,                 big_sur:        "1286e09bd29c0520290e7e0c3100a4bb34c1d8144caa3f76a9d8dd21fb6d1769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc84ad685fce1fac730610df3062fc8158c44df2f707d3a4b51719f7ae41d2ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/libusb-config", "--libs"
  end
end
