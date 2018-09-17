class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.0/freeciv-2.6.0.tar.bz2"
  sha256 "7c20399198d6c7d846fed9a69b02e01134ae5340a3ae0f99d1e38063ade6c999"

  bottle do
    sha256 "d7c127c1bbe7d964de0fe50dcd44515d644e805511b1418f05cf1b9c9285d9c8" => :mojave
    sha256 "8ba7771987465daac08790cf9325c8d1c28df67cb55a1e3a257504618c1a803b" => :high_sierra
    sha256 "e123133c2ebbac4dce6d5b443f25b94cf8c90359c745fdfcd43fa56110817bb9" => :sierra
    sha256 "933abaa9e21126537f6864f2e6389480df81c8b38f4a47e2beea72ecfd0928da" => :el_capitan
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
