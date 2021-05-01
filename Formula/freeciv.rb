class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.4/freeciv-2.6.4.tar.bz2"
  sha256 "40db957766acbd49c5af15afd1711da996b6681be7abee3352c5f2539c10c1ce"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_big_sur: "bca6efd22e2c7bc46b8b49c4aca7c989c6e4d310a56838d0f5a6de0d600e24b3"
    sha256 big_sur:       "88ffaca52bc57b1f7aed11ddc8707e9d5f2cac3bfa3dc8d43d42489ffb95b090"
    sha256 catalina:      "25fede03622a9d2df46e55353a5852f35e348f23930733d608df2b8192d95249"
    sha256 mojave:        "dd01bd71b484df77dcbeaa74335134ae89c2dbfaa4d38b5d260ce14c53ff92ad"
  end

  head do
    url "https://github.com/freeciv/freeciv.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
      --disable-silent-rules
      --disable-sdltest
      --disable-sdl2test
      --disable-sdl2framework
      --enable-fcdb=sqlite3
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
    assert_predicate testpath/"classic6.mediawiki", :exist?

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
