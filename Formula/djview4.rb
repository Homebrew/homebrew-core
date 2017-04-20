class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.io/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.6.tar.gz"
  sha256 "8446f3cd692238421a342f12baa365528445637bffb96899f319fe762fda7c21"
  revision 1

  bottle do
    sha256 "8cc214252ddf146d8e4b65210436036197b556ff40b136e2784a1d95c9a4f43e" => :sierra
    sha256 "82c4310f2e0af35fb98fce109660ec79bdc4075205b8f5c053d58b4b87b37099" => :el_capitan
    sha256 "92dec68ad76d1e5a1e158b6b1a700d119f4a651cafd45c8cd4a787ecf31ff402" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "qt"

  def install
    inreplace "src/djview.pro", "10.6", MacOS.version
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install "src/djview.app"
  end
end
