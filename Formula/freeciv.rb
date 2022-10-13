class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.4/freeciv-3.0.4.tar.xz"
  sha256 "d9a83fe9268e6b9d0fbe933f1f8b5c391b7e3ad72333d2d4e35cfb2e3ce9adb9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_monterey: "f3c319b041d5a5f81693f83b1e87e8519a1fe4a7e987492b63dcb6ab74b81781"
    sha256 arm64_big_sur:  "d3340ac8da9a72f397d7d0c9a24f44bec3d4c0e8bf5de2e8fc06bcaa8d486816"
    sha256 monterey:       "77fcaee302c90de1abf52a93d214e20625170b1276ee383723becaf4e41c6223"
    sha256 big_sur:        "ed32f919ad2fbd1a982a05682bd0bfdd08ecfd7032896b2b13976d320d6f47be"
    sha256 catalina:       "0d8d998a767905ce2d62f153d8fbc7ae96e88a80351432a34dc9ead21284e119"
    sha256 x86_64_linux:   "48fab150b4422cfc6065220546490459b19211b8e9aa14beb51d4c6923109ec3"
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
