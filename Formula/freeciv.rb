class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.2/freeciv-3.0.2.tar.xz"
  sha256 "7407ea1a08267b1c5ee3439dc2db5c2d7b90ece7fcc3664ca2ad594435a57175"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_monterey: "07a23ce564fdd66cfc586ece9c48e74b9d10632edd2a2a8092fa93b7ce1927da"
    sha256 arm64_big_sur:  "bd9fbf2db4db09448e7602c7de80a1c1f041bb3c143cbd6bdeefbb48c4109ea9"
    sha256 monterey:       "d17179050529f4328de7850f4502d64df58eca76186a65890737935efec273b1"
    sha256 big_sur:        "cd783c18e420cadf929b24f5f490c3ba3b27d6749909b86efd9e52dee39a8456"
    sha256 catalina:       "9d1d460f941eb72d1ccd84a2eebaf0d0f124e1c6cce3c4c71a79061b06626f97"
    sha256 x86_64_linux:   "31600bb2ec19192111e6e7917b38f5c63a9a6a5f30a3ba8e1ff03655d670f728"
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
    assert_predicate testpath/"civ2civ36.mediawiki", :exist?

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
