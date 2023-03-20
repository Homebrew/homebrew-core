class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.6/freeciv-3.0.6.tar.xz"
  sha256 "40e701157b957a2eb3c4548e5b819d06521c2ad1d47ae926be5117c7d6ace442"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_ventura:  "7e6778de44f4bdde89579138feb4c2552fe669de57ae15f95eaa1e11d39782d6"
    sha256 arm64_monterey: "057aef3311a43db28c71e0bf984fad9a3cd9f12faa3bd464061391df37ab1e72"
    sha256 arm64_big_sur:  "bceb77f4f1fb2a272361a970050ee086e0b28af15ab59b30d3180957aec15739"
    sha256 ventura:        "cfadf10dbd2353f791c8b18a0236b7a82f07726eebc57a0d99ad13e1823917d1"
    sha256 monterey:       "12ef7c9b8d97abe449514575d4aae8abc5280d6de129f1ba4fe10237394d66dd"
    sha256 big_sur:        "4b8cedb59f300fa98a8197eed9118e1c54fadd5d26a89adfc76c80923d83a9ca"
    sha256 x86_64_linux:   "86325e34c3139fc2bd4b6f11697068b8546014d0c39706a4faffd3fb4410af11"
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
