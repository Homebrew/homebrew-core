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
    sha256 arm64_ventura:  "e1c759f0a52bc1e257df771e19b21c4b6d0344e86c4c8865989d5a59716a05a3"
    sha256 arm64_monterey: "d61fc79817b2c8b56cdea063ce11e9e90bb6f1ba88c412aff600369e81bd7d9b"
    sha256 arm64_big_sur:  "58c8d87468b729f7faaf89233902f74f984c6bc9ae1580905fb6b37386133c22"
    sha256 ventura:        "3dd05f6772b3e0563f3eadfdb4ae7a5b3cc6a40981b7707104fb5a500f037bb6"
    sha256 monterey:       "0c9142560d9004315f4ae7dad894681e038dab5a4dff2a05dd14c63a2bb1830c"
    sha256 big_sur:        "c9571c33afaf58c10542ef8cd1b996bf58992c50463b39291d89a6cf230f6431"
    sha256 catalina:       "4c7be3976d09319dcbefb794fc574d427c2f370de0d84a57a7657ab20dec97b4"
    sha256 x86_64_linux:   "e778ee2ab8f1aca3ff12845c5f71fa69e107f99c87561ddc3b1eb7dc6dbb80d5"
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
