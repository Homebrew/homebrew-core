class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.5/2.5.10/freeciv-2.5.10.tar.bz2"
  sha256 "c8a14156562dce2f0a7b96390c2d5a35314f1124c448782a6a47b0c51cfcb302"

  bottle do
    sha256 "ecdb5648100114a60080b3420e876fd8d164f08077a58d858f900b5454a613a9" => :high_sierra
    sha256 "be3dcbdc6072c9c5c374340c96b21659c012adaf85901096424889936c23e7fe" => :sierra
    sha256 "c8a9e03991705f4edc0c8214cb2bcde05dbc1c5ca83b716db266e3a48c2f6e30" => :el_capitan
    sha256 "1148d9d5c8893eda436a3fc619a355a89be56b885b0fb75e1ab59d3c250c5477" => :yosemite
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
