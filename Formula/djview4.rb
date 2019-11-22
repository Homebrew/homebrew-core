class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.io/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.6.tar.gz"
  sha256 "8446f3cd692238421a342f12baa365528445637bffb96899f319fe762fda7c21"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "11c318b224adb9e2575c754c1a3ad6a4c5f4e2febe4dd0a81d63e6ee748af765" => :catalina
    sha256 "f8e5afe939077fd62f6c946323e9f857572ba8c696dd6f1caccb33fbe84dd328" => :mojave
    sha256 "a9c95fcc6bf1dec71109b4bf32f827db003375682b522efe20743f6cb2e8a800" => :high_sierra
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
