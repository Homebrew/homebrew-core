class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.5/2.5.11/freeciv-2.5.11.tar.bz2"
  sha256 "4c9c526952fe977cb4b302b8ccf75798fd066c6dde670f72f677fe4964259aad"
  revision 1

  bottle do
    sha256 "b054ce3c05e877006cf79b4c99cd2b63dfc8ce0f68c9d70c2f3ab2d874d6722e" => :high_sierra
    sha256 "5c2378c9054dee7927d0e14970a95c58aa9919e7ae0d525057f99439ab524539" => :sierra
    sha256 "1d3e7934bc8cdd6448251cdde65b8e29a53c1923a952ce2cc5fc04418170ddc3" => :el_capitan
  end

  head do
    url "https://github.com/freeciv/freeciv.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  option "without-nls", "Disable NLS support"
  option "without-sdl", "Disable the SDL Freeciv client"

  depends_on "gettext" if build.with? "nls"
  depends_on "icu4c"
  depends_on "pkg-config" => :build
  depends_on "readline"

  depends_on "sdl" => :recommended
  if build.with? "sdl"
    depends_on "freetype"
    depends_on "sdl_image"
    depends_on "sdl_gfx"
    depends_on "sdl_mixer"
    depends_on "sdl_ttf"
  end

  depends_on "gtk+" => :recommended
  depends_on "gtk+3" => :optional
  if build.with?("gtk+") || build.with?("gtk+3")
    depends_on "atk"
    depends_on "glib"
    depends_on "pango"
  end
  depends_on "gdk-pixbuf" if build.with? "gtk+3"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    if build.without? "nls"
      args << "--disable-nls"
    else
      gettext = Formula["gettext"]
      args << "CFLAGS=-I#{gettext.include}"
      args << "LDFLAGS=-L#{gettext.lib}"
    end

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
    assert_predicate testpath/"manual6.html", :exist?

    server = fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"test.log", :exist?
  end
end
