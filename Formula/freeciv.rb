class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.2/freeciv-2.6.2.tar.bz2"
  sha256 "6181ef3d3c76264383aabbe0eaf1550d8a65ca42639e6c17cc2938165e176c8f"

  bottle do
    sha256 "581a684f9e7972fe79e0bfbf6d5331b14fc5194f39f947c6e4356c64865b7964" => :catalina
    sha256 "e8459416150dcfddc8638fcdd8f986daf74b95d4b0cccf1ab5693afd7a69eb32" => :mojave
    sha256 "148cffcc2e49c0d9e32e4bea5cb8b2414ac386b27243729ca44826297ed5c7f4" => :high_sierra
  end

  head do
    url "https://github.com/freeciv/freeciv.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "icu4c"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
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

    server = fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"test.log", :exist?
  end
end
