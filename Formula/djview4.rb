class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "http://djvu.sourceforge.net/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.6.tar.gz"
  sha256 "8446f3cd692238421a342f12baa365528445637bffb96899f319fe762fda7c21"

  bottle do
    sha256 "0b5835bf2e00677dbe5ac47fc17f93fc7e36575c7f2b8820e80f98a83639c224" => :el_capitan
    sha256 "12b09ccc4d3c86502407789cf187ea09622ed44988ca0ca63b42114520639898" => :yosemite
    sha256 "864c1b3ae86440205b6f045b2fbc6db5b8e3af241ccf3f99b7f3ce9683ef66c4" => :mavericks
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
