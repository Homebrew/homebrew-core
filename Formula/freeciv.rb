class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.7/freeciv-3.0.7.tar.xz"
  sha256 "f6e606f17ed03d971272883f1a4879f5c1c2c247f64b8edefa6a25c8a2a8dac4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_ventura:  "ed7c791e870c95ab9c570552ccd1d12e9a2c231571a6867a8a1bd057615f7999"
    sha256 arm64_monterey: "57026b7d3177f5becaddbe9962d0afe1db0ae188fecba8b783c4359722fb5395"
    sha256 arm64_big_sur:  "b8c69b6744365a7f16f4fb2e08e9871dd8504d80070abe353b8dedd73cf3cf86"
    sha256 ventura:        "12de702da90fd4927c742459181f70f324740b2847afd901085039f667872b18"
    sha256 monterey:       "58febf6100c6424325fa5939c37874655a0b46e60cf0ee8d21525fcd3c459164"
    sha256 big_sur:        "d9c28c9c6236950e6cc107e2be1e961be61b63ddf774152b1e0349a42c667b90"
    sha256 x86_64_linux:   "49db130c81d4e1c640a3133b36655ba2dcf79265f837c672a3b9becb802fe81b"
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
