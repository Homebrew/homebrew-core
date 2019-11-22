class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/0.5.20150702/libspiro-0.5.20150702.tar.gz"
  sha256 "db1a48659ed3df05521829855b367ab27035c25db2d6a51b868c733b5abf9f7c"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "95b1fa2d825d9f7485a3740e989550812778d2d94f060513d4e1e71903eafa4f" => :catalina
    sha256 "934e0ccd8d371ac24456e1d3d63db4621a3736401105d99b055018b3e941b851" => :mojave
    sha256 "1429ee36073ef51e18ef636519122059eccdd17d005e56c28fbb2fe6429b3e5a" => :high_sierra
    sha256 "ed2eb6d7502263bbf73b9a85dfeea23ad76238996c06e2a4b729a687537e9584" => :sierra
    sha256 "ba2ac132368792d5715eb39a7b0e452fba5a222977ec30b9c5ff09728acfd0e0" => :el_capitan
    sha256 "408083484eb78518514bd2613f019bd03ac94e791b8302721187eeaf5c775479" => :yosemite
    sha256 "7bbae215d77ea9b5977f066b2fa646821933f5ed4cbc972e4c50fc5a1708725e" => :mavericks
  end

  head do
    url "https://github.com/fontforge/libspiro.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <spiroentrypoints.h>
      #include <bezctx.h>

      void moveto(bezctx *bc, double x, double y, int open) {}
      void lineto(bezctx *bc, double x, double y) {}
      void quadto(bezctx *bc, double x1, double y1, double x2, double y2) {}
      void curveto(bezctx *bc, double x1, double y1, double x2, double y2, double x3, double t3) {}
      void markknot(bezctx *bc, int knot) {}

      int main() {
        int done;
        bezctx bc = {moveto, lineto, quadto, curveto, markknot};
        spiro_cp path[] = {
          {-100, 0, SPIRO_G4}, {0, 100, SPIRO_G4},
          {100, 0, SPIRO_G4}, {0, -100, SPIRO_G4}
        };

        SpiroCPsToBezier1(path, sizeof(path)/sizeof(spiro_cp), 1, &bc, &done);
        return done == 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspiro", "-o", "test"
    system "./test"
  end
end
