class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/0.5.20150702/libspiro-0.5.20150702.tar.gz"
  sha256 "db1a48659ed3df05521829855b367ab27035c25db2d6a51b868c733b5abf9f7c"
  version_scheme 1

  bottle do
    cellar :any
    revision 1
    sha256 "b74aa7a260b965d0910c86eff34bb29268efe56d2050063ad21e5261b7767697" => :el_capitan
    sha256 "bc389fbed945d055b3acac18eeee82d36e4d5174be1b5e42e9759ed09a74dde1" => :yosemite
    sha256 "b7b9bc066871be5999c7c49fa400a3eafa985aefcf1362dd19370981c686db5a" => :mavericks
    sha256 "49ffd6343c706612bfb641a756e31944ee7b712dd25198413150bfd383d907fd" => :mountain_lion
  end

  head do
    url "https://github.com/fontforge/libspiro.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
    (testpath/"test.c").write <<-EOS.undent
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
