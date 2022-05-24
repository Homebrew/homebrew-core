class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.6/freeciv-2.6.6.tar.bz2"
  sha256 "7bcfe5dd3c081122e7cde7cdb24f57c3681d6a9667496faed207a91ac3165811"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_monterey: "d0cd6013001decd5b74d1ac8d7bba8d6e070bb2c27ed8cce5a41622d13aef267"
    sha256 arm64_big_sur:  "3cb7282942ed5e1c4b4d7e48cbb3ba57554f597cd77e4a55b57b002102e6c90f"
    sha256 monterey:       "22fe64446282ce7df3f109ea14322c7f33e28dea831fea3a7e1d7df0cabfa986"
    sha256 big_sur:        "09cb343f164c953f7c6c44e24fa706f35b64e21ff711a930a10e0c4336ad94bd"
    sha256 catalina:       "c3a9840643191f575c69eff922381cd713a2e2a7249a05f752edd8e3a4ebf673"
    sha256 x86_64_linux:   "b481371af3c4dcd5c8ab1a4894b4d2a85d2f4953e8c72de4f757fbb3b9887af8"
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
