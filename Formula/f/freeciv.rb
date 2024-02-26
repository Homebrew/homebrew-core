class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.10/freeciv-3.0.10.tar.xz"
  sha256 "c185c8ea0d6a2e974a5ad12fb837ca3ceb9aed3e7e884355f01035f5e779d23c"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "6184468e0cbb401519ed58c38e9477f4b497a35c74c70c113598cf4b4ed9e24b"
    sha256 arm64_ventura:  "3504a50f1724087bda8d6163e8d5a344a4dee11005448cf6edbbcf97ba6532c0"
    sha256 arm64_monterey: "514e2d47bc9b1881baf97844fbf8a8e3b652025ed979c7f3b6b5d1ba6fc8fa7c"
    sha256 sonoma:         "8da17f4cc949c28c37c31e53214ba55ca05be1c5773cc19dd7ac0335114b19fb"
    sha256 ventura:        "a71b85fceeb4568029c088e6083bdde34138f21dc0d360ad12cf168d0b1341e1"
    sha256 monterey:       "fcd2bddc8d41cc47e435ff767eaab56cd34c5243f0f536295568ae2bcd85d99b"
    sha256 x86_64_linux:   "02aa948caedc12bfcfeaa27a1f0ab5f8c0e8b5ada7c9589a4e786a2136b2acf5"
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
  depends_on "at-spi2-core"
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
