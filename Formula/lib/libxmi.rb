class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "https://ftpmirror.gnu.org/gnu/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "97d08e23a85103e733e90fa33b96e59f5f141f6081e5d09f9c8135e0000d221a"
    sha256 cellar: :any,                 arm64_sequoia:  "02dd0c4d25870675c7609b021e7030213aeb55b2799eb0c4d981842637ec29f3"
    sha256 cellar: :any,                 arm64_sonoma:   "c3b129b35e3e50b1bdba2987150164d3e553d31118119c94691d17b6e0297e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932b2ebc8aa7c03aa6f8f372f5ec3e2def0dc6d5f628dfbfcd7952c52b4c8384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4415d53e7ab98998a088de1148339142edd47d8abf8058d9014b077907ef07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f62b288c26ca17a79f7c066f82a0a26b84e768960095eefdcf6c0c3b420d4a1"
    sha256 cellar: :any,                 sonoma:         "0326bd04964e9707c76d9f532e50e4871d78f519b721f7cc8f502ec7f64e3f6f"
    sha256 cellar: :any_skip_relocation, ventura:        "bad9ab9655d2e75c8d999725163da71b9061f05f8c9bf5ff89b5e81c1b0fdb11"
    sha256 cellar: :any_skip_relocation, monterey:       "fafba3428a0f8d222ed035043883dc2230be492abc71fd8eb140b2b3e1884922"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5e9c2fce42f171773589cb0b1bfbf88cadf5036d86a6f502d5f415b8ad20f62"
    sha256 cellar: :any_skip_relocation, catalina:       "eabebd41538c5b53f5ac3d25e71636b8d3561150f4622769107c58a10283e525"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ede22f9abf05a18ec44e5009276815c87ce99bbd7c3a2699d58b8ab31ea8d4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82bdaa8f3c6d1d63dc572bf315c10418d39a0f1e12407dc187f793d8e6e9609"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.linux? || (OS.mac? && MacOS.version >= :ventura)
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <xmi.h>
      int main () {
        miPoint points[4] = {{.x = 25, .y = 0}, {.x = 0, .y = 0}, {.x = 0, .y = 25}, {.x = 35, .y = 22}};
        miArc arc = {.x = 20, .y = 15, .width = 30, .height = 16, .angle1 = 0 * 64, .angle2 = 270 * 64};
        miPixel pixels[4] = {1, 2, 3, 4};
        unsigned int dashes[2] = {4, 2};
        miGC *pGC;
        miPaintedSet *paintedSet;
        miCanvas *canvas;
        miPoint offset = {.x = 0, .y = 0};
        int i, j;
        pGC = miNewGC (4, pixels);
        miSetGCAttrib (pGC, MI_GC_LINE_STYLE, MI_LINE_ON_OFF_DASH);
        miSetGCDashes (pGC, 2, dashes, 0);
        miSetGCAttrib (pGC, MI_GC_LINE_WIDTH, 0);
        paintedSet = miNewPaintedSet ();
        miDrawLines (paintedSet, pGC, MI_COORD_MODE_ORIGIN, 4, points);
        miDrawArcs (paintedSet, pGC, 1, &arc);
        canvas = miNewCanvas (51, 32, 0);
        miCopyPaintedSetToCanvas (paintedSet, canvas, offset);
        for (j = 0; j < canvas->drawable->height; j++) {
          for (i = 0; i < canvas->drawable->width; i++) {
            printf ("%d", canvas->drawable->pixmap[j][i]);
          }
          printf ("\\n");
        }
        miDeleteCanvas (canvas);
        miDeleteGC (pGC);
        miClearPaintedSet (paintedSet);
        miDeletePaintedSet (paintedSet);
        return 0;
      }
    C

    expected = <<~EOS
      330022220044440033330022220000000000000000000000000\n300000000000000000000000000000000000000000000000000
      300000000000000000000000000000000000000000000000000\n000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000\n400000000000000000000000000000000000000000000000000
      400000000000000000000000000000000000000000000000000\n400000000000000000000000000000000000000000000000000
      400000000000000000000000000000000000000000000000000\n000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000\n200000000000000000000000000000000000000000000000000
      200000000000000000000000000000000000000000000000000\n200000000000000000000000000000000000000000000000000
      200000000000000000000000000000000000000000000000000\n000000000000000000000000000000022220044440000000000
      000000000000000000000000000330000000000000030000000\n300000000000000000000000033000000000000000003300000
      300000000000000000000000000000000000000000000030000\n300000000000000000000040000000000000000000000000000
      300000000000000000000400000000000000000000000000020\n000000000000000000004000000000000000000000000000002
      000000000000000000004000000000330044000000000000002\n400000000000000000440022220033000000000000000000002
      400000220033330044000000000000000000000000000000000\n440022000000000000002000000000000000000000000000000
      000000000000000000000200000000000000000000000000000\n000000000000000000000020000000000000000000000000000
      000000000000000000000002000000000000000000000000000\n000000000000000000000000003000000000000000000000000
      000000000000000000000000000333000000000000000000000\n000000000000000000000000000000004444000000000000000
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxmi", "-o", "test"
    assert_equal expected, shell_output("./test")
  end
end
