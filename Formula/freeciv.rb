class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.7/freeciv-3.0.7.tar.xz"
  sha256 "f6e606f17ed03d971272883f1a4879f5c1c2c247f64b8edefa6a25c8a2a8dac4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_ventura:  "850bb6f673bf1fe86fb52b60515fa68ffcc310d6c6665969078700de2706c4cb"
    sha256 arm64_monterey: "676717f01ff7de006f19f580b8acdfeaccc4aa11fd72cdf697942211fe3d3854"
    sha256 arm64_big_sur:  "17d6e04aff3db915df92052ee3ecf86744198331b852053432e25035ccaa7640"
    sha256 ventura:        "a2ca37d415704d607087f0935221b13c00eeeb773cf479d26de80673e749b382"
    sha256 monterey:       "77463a053f2b0dd5aa2be698462f68d49e457785bdac54013bc6cbb08804fb17"
    sha256 big_sur:        "03d11934da65d1754e0210b5e6446fe467f2ecedb195f732c3e2bf8aadf2d488"
    sha256 x86_64_linux:   "a1a22fcb8b5b4972ca8b02e00c75742bd12266220491b8eb55adcbaea8eb7af3"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "master"

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
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency

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
    assert_predicate testpath/"civ2civ36.mediawiki", :exist?

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
