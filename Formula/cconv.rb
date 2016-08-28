class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://github.com/xiaoyjy/cconv"
  url "https://github.com/xiaoyjy/cconv/archive/v0.6.3.tar.gz"
  sha256 "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84"

  bottle do
    cellar :any
    sha256 "07e137c61d8d908275c223e703205205060ccf08c3694407398725dd8ad3233d" => :el_capitan
    sha256 "65436699d38a250324868565690c295e9668d96f9fa5f1f8d23dfc2dff6fc122" => :yosemite
    sha256 "6ccd7bc724cb38fb3af7ccb07fb4b45cc6486390c6c7030dc2f9cd89e7531cf4" => :mavericks
    sha256 "21adc67fe672719cbfc93e940d044a2b2ceb32653cc1a901b79e251c3fb6d090" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "LDFLAGS", "-liconv"

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    rm_f include/"unicode.h"
  end

  test do
    system bin/"cconv", "-l"
  end
end
