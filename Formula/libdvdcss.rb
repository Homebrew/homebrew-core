class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.1/libdvdcss-1.4.1.tar.bz2"
  sha256 "eb073752b75ae6db3a3ffc9d22f6b585cd024079a2bf8acfa56f47a8fce6eaac"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a12b8c3d6f8e88394b86b711bfda78a465ba8a0fdf028e80f7676a5a1afaf76c" => :high_sierra
    sha256 "bab4dbb3fbda6bdb3c21ebb1c925c242e0cc14a247fcaca552ab609710677b23" => :sierra
    sha256 "c15f5de6e9bb695e3d5325c4732e83c12ac5142a5ae1ba1facc098560822b8a1" => :el_capitan
    sha256 "c93bcd80c6ecdc46f9b74eeb82c5834d42c1380bd4b8070dbd9a80354d1726d7" => :yosemite
    sha256 "09b948452ac6499dd896cf96ae9289028bfb73c143d93b3f73067369a690e04c" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libdvdcss.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
