class Pgplot < Formula
  desc "Device-independent graphics package for making simple scientific graphs"
  homepage "https://www.astro.caltech.edu/~tjp/pgplot/"
  url "ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot522.tar.gz"
  mirror "https://distfiles.macports.org/pgplot/pgplot522.tar.gz"
  mirror "https://gentoo.osuosl.org/distfiles/pgplot522.tar.gz"
  version "5.2.2"
  sha256 "a5799ff719a510d84d26df4ae7409ae61fe66477e3f1e8820422a9a4727a5be4"
  revision 8

  bottle do
    cellar :any
    sha256 "a0632e523fa04f95888c94adb1e9dda335e35ed871f8c0c96f25390d430e3db5" => :catalina
    sha256 "3d1afcf5d6a2dbd3a0707a984aa173787f1e58ed8b75139464d59bc28d9f31c4" => :mojave
    sha256 "e38e9fca27499543c9239d9c655c1cf328364d127aa028d48c6a92a19d85c41f" => :high_sierra
    sha256 "70aa46b991b8f502aa5c73c6fb56a0f9851396c147384ebd40a4b316d6c1c196" => :sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "libpng"
  depends_on :x11

  # from MacPorts: https://trac.macports.org/browser/trunk/dports/graphics/pgplot/files
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b520c2d/pgplot/patch-makemake.diff"
    sha256 "1af44204240dd91a59c899714b4f6012ff1eccfcad8f2133765beec34d6f1423"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b520c2d/pgplot/patch-proccom.c.diff"
    sha256 "93c55078389c660407c0052569d3ed543c92107c139c765d207b90687cfb7a0c"
  end

  def install
    ENV.deparallelize
    ENV.append "CPPFLAGS", "-DPG_PPU"

    # re-hardcode the share dir
    inreplace "src/grgfil.f", "/usr/local/pgplot", share
    # perl may not be in /usr/local
    inreplace "makehtml", "/usr/local/bin/perl", which("perl")
    # prevent a "dereferencing pointer to incomplete type" in libpng
    inreplace "drivers/pndriv.c", "setjmp(png_ptr->jmpbuf)", "setjmp(png_jmpbuf(png_ptr))"

    # configure options
    (buildpath/"sys_darwin/homebrew.conf").write <<~EOS
      XINCL="#{ENV.cppflags}"
      MOTIF_INCL=""
      ATHENA_INCL=""
      TK_INCL=""
      RV_INCL=""
      FCOMPL="gfortran"
      FFLAGC="-ffixed-line-length-none"
      FFLAGD=""
      CCOMPL="#{ENV.cc}"
      CFLAGC="#{ENV.cppflags}"
      CFLAGD=""
      PGBIND_FLAGS="bsd"
      LIBS="#{ENV.ldflags} -lX11"
      MOTIF_LIBS=""
      ATHENA_LIBS=""
      TK_LIBS=""
      RANLIB="#{which "ranlib"}"
      SHARED_LIB="libpgplot.dylib"
      SHARED_LD="gfortran -dynamiclib -single_module $LDFLAGS -lX11 -install_name libpgplot.dylib"
      SHARED_LIB_LIBS="#{ENV.ldflags} -lpng -lX11"
      MCOMPL=""
      MFLAGC=""
      SYSDIR="$SYSDIR"
      CSHARED_LIB="libcpgplot.dylib"
      CSHARED_LD="gfortran -dynamiclib -single_module $LDFLAGS -lX11"
    EOS

    mkdir "build" do
      # activate drivers
      cp "../drivers.list", "."
      %w[GIF VGIF LATEX PNG TPNG PS
         VPS CPS VCPS XWINDOW XSERVE].each do |drv|
        inreplace "drivers.list", %r{^! (.*\/#{drv} .*)}, '  \1'
      end

      # make everything
      system "../makemake .. darwin; make; make cpg; make pgplot.html"

      # install
      bin.install "pgxwin_server", "pgbind"
      lib.install Dir["*.dylib", "*.a"]
      include.install Dir["*.h"]
      share.install Dir["*.txt", "*.dat"]
      doc.install Dir["*.doc", "*.html"]
      (share/"examples").install Dir["*demo*", "../examples/pgdemo*.f", "../cpg/cpgdemo*.c", "../drivers/*/pg*demo.*"]
    end
  end

  test do
    # build Fortran version of test program
    (testpath/"pgtest.f90").write <<~EOS
         PROGRAM SIMPLE
         INTEGER I, IER, PGBEG
         REAL XR(100), YR(100)
         REAL XS(5), YS(5)
         data XS/1.,2.,3.,4.,5./
         data YS/1.,4.,9.,16.,25./
         IER = PGOPEN('pgtest.png/PNG')
         IF (IER.LE.0) STOP
         CALL PGENV(0.,10.,0.,20.,0,1)
         CALL PGLAB('(x)', '(y)', 'A Simple Graph')
         CALL PGPT(5,XS,YS,9)
         DO 10 I=1,60
             XR(I) = 0.1*I
             YR(I) = XR(I)**2
      10 CONTINUE
         CALL PGLINE(60,XR,YR)
         CALL PGCLOS
         END
    EOS
    system "gfortran", "-o", "pgtest", "pgtest.f90", "-L#{lib}", "-lpgplot"

    # build C version of test program
    (testpath/"cpgtest.c").write <<~EOS
      #include "cpgplot.h"

      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>

      int main()
      {
        int i;
        static float xs[] = {1.0, 2.0, 3.0, 4.0, 5.0 };
        static float ys[] = {1.0, 4.0, 9.0, 16.0, 25.0 };
        float xr[60], yr[60];
        int n = sizeof(xr) / sizeof(xr[0]);
        if(cpgopen("cpgtest.png/PNG") <= 0)
          return EXIT_FAILURE;
        cpgenv(0.0, 10.0, 0.0, 20.0, 0, 1);
        cpglab("(x)", "(y)", "A Simple Graph");
        cpgpt(5, xs, ys, 9);
        for(i=0; i<n; i++) {
          xr[i] = 0.1*i;
          yr[i] = xr[i]*xr[i];
        }
        cpgline(n, xr, yr);
        cpgclos();
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-c", "-I#{include}", "cpgtest.c"
    system "gfortran", "-o", "cpgtest", "cpgtest.o",
           "-L#{lib}", "-lcpgplot", "-lpgplot"

    # Produce PNG output with both programs and check if identical
    system "./pgtest"
    system "./cpgtest"
    assert_predicate testpath/"pgtest.png", :exist?
    assert_predicate testpath/"cpgtest.png", :exist?
    assert_equal (testpath/"pgtest.png").read, (testpath/"cpgtest.png").read
  end
end
