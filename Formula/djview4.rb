class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "http://djvu.sourceforge.net/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.6.tar.gz"
  sha256 "8446f3cd692238421a342f12baa365528445637bffb96899f319fe762fda7c21"

  bottle do
    sha256 "d2672b78d0e74e619030d0ebf4b2ab0b85fd63ae394c7258177ea2f357269449" => :sierra
    sha256 "1868bc87f83e5e480fbb057beff8fbeedfe6c0f7b05150fcef5eb2deb1b23082" => :el_capitan
    sha256 "f15753fce1533b948848a673ba36a201872c257fbabe2e4acf82ee42fc265e49" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "qt5"

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
