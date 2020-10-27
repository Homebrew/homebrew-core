class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.0/libdvdnav-6.1.0.tar.bz2"
  sha256 "f697b15ea9f75e9f36bdf6ec3726308169f154e2b1e99865d0bbe823720cee5b"
  revision 1

  bottle do
    cellar :any
    sha256 "e20bd00c923e4e837a1eac6f89933377afd17957be74a175734d7896efceb27a" => :catalina
    sha256 "6c13d8aa2220232e9a0e5317371bd52909ec55b0bb08ed7b591612b60814dc7a" => :mojave
    sha256 "a9c90f8109ce908ffc4fc0b6972ff4869638de8f52787bedd2c471ce457e1edf" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
