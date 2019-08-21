class Libagar < Formula
  desc "Cross-platform GUI toolkit"
  homepage "https://libagar.org/"
  url "http://stable.hypertriton.com/agar/agar-1.5.0.tar.gz"
  sha256 "82342ded342c578141984befe9318f3d376176e5f427ae3278f8985f26663c00"
  revision 1
  head "https://dev.csoft.net/agar/trunk", :using => :svn

  bottle do
    sha256 "05a3ac6970817b2ea375fa56e384da8a954a0ac75948cafc5641ff724a35446f" => :mojave
    sha256 "e04ccaee7f578f806d5544fe130febfb8de0bf3ca7fa3ec3562a623ebf2c9039" => :high_sierra
    sha256 "718b79132faa46ad0e8d59dd1ae647ecdf89d6e51a9051ad9fdf08becf5c0241" => :sierra
    sha256 "b0908e5e28f7a7acce3ec0a333f513afedaef0ef464c75a1faa74a35e4eb3291" => :el_capitan
    sha256 "c030ffe2c1a718afb161bef162b9252a9dd3dad5e4318c818a3f3203c27bdf0d" => :yosemite
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "sdl"

  def install
    # Parallel builds failed to install config binaries
    # https://bugs.csoft.net/show_bug.cgi?id=223
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man}" # --mandir for configure didn't work
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <agar/core.h>
      #include <agar/gui.h>

      int main() {
        AG_Window *win;
        if (AG_InitCore("test", AG_VERBOSE) == -1 || AG_InitGraphics(NULL) == -1) {
          return 1;
        } else {
          return 0;
        }
      }
    EOS
    flags = %W[
      -I#{include}/agar
      -I#{Formula["sdl"].opt_include}/SDL
      -I#{Formula["freetype"].opt_include}/freetype2
      -I#{Formula["libpng"].opt_include}/libpng
      -L#{lib}
      -L#{Formula["sdl"].opt_lib}
      -L#{Formula["freetype"].opt_lib}
      -L#{Formula["libpng"].opt_lib}
      -L#{Formula["jpeg"].opt_lib}
      -lag_core
      -lag_gui
      -lSDLmain
      -lSDL
      -lfreetype
      -lpng16
      -ljpeg
      -Wl,-framework,Cocoa,-framework,OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
