class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.5/2.5.7/freeciv-2.5.7.tar.bz2"
  sha256 "ffe36736db6a64893681e9eea8b90f7abe05eaebe6b777e82149a98cad6dbed2"

  bottle do
    sha256 "3a4e8955bb518bc8fd7efd9c4ed79bf97cfda25ea9bd6a4befdd8f51d05be172" => :sierra
    sha256 "cc71adbf22f5964168e3d3eec8a60413021768300b69b289b567c37c98341b23" => :el_capitan
    sha256 "e136a27f3e77a9c7c6c0babbc54027bc0bcb638c5136ca9294ce993b942356ce" => :yosemite
  end

  head do
    url "svn://svn.gna.org/svn/freeciv/trunk"
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
    File.exist? testpath/"manual6.html"

    server = fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    Process.kill("TERM", server)
    File.exist? testpath/"test.log"
  end
end
