class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.5/freeciv-2.6.5.tar.bz2"
  sha256 "2e64e1c74dae12acb17bbf5daa980efc7e9fd57820afed5135319ca95291ec59"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_big_sur: "dc27602cdb795f299647d4262758409775599ee932606aad9fa34a78a8d102aa"
    sha256 monterey:      "bdae2e778459cc59055d375a7664351db7abdb5e31fc90d50e89258276f20cc3"
    sha256 big_sur:       "fa1955a0573dfabfb99742ca216f2caad95053e5909975990504097063ff239f"
    sha256 catalina:      "e93e825aebcb5c046e1b8114a366d8010f9e30a35120543327dbb7f14303cd75"
    sha256 mojave:        "5365cbee42fe93a79db42fe7d1f9690f523090d9b612ef5f508a70ed83063179"
    sha256 x86_64_linux:  "4da618352125e2a2fbe8a2567ca18e8ac55271a0c2e244a000b7f72867ebb620"
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
      --enable-client=gtk3.22
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
