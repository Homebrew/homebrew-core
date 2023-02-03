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
    sha256 arm64_ventura:  "0f79665ff43b4aa6bffa558758b586ad200feabe17a89a2f128213f8a1cacce4"
    sha256 arm64_monterey: "23e80547457331c26283882a112aeef5bd9943d71db9e5700bee0033e7ebb183"
    sha256 arm64_big_sur:  "ee2652bb3113c53bd203edf8f5213ae7a5fb1e4c85ce7dac13c74ff07cca7795"
    sha256 ventura:        "8cf40b7727f945d9da0ac1b817ae4d4fe4159b5a46815fdd3a15709ec84a4939"
    sha256 monterey:       "b77e4ad9a59ab4f56c7e1facdf3e293108871fbc4de4525eaeef7dba5024843c"
    sha256 big_sur:        "14327d53750eeb0510a38c74b72cca56379a5c37684000397e89b084717f5bf8"
    sha256 x86_64_linux:   "4b58af714d00813ae5207c50ec3ab393f445106c7e2000de5f886b439a1d1ab5"
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
