class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.2/freeciv-2.6.2.tar.bz2"
  sha256 "6181ef3d3c76264383aabbe0eaf1550d8a65ca42639e6c17cc2938165e176c8f"

  bottle do
    sha256 "827459a0ad236b5068cca01b5ccd64d5c59e833c98a5041ae0684f87813c01f3" => :catalina
    sha256 "a2a0b5345d3891b3b9a3337fe1ecd21d0cfbfa1238895ca7c66659c5489718d7" => :mojave
    sha256 "3bd85c48fa84398047f209cbabc343934cef3eff3426645ec3dda392cc7e57f7" => :high_sierra
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
