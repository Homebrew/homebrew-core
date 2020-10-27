class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.6.tar.gz"
  sha256 "fc2c0d899c32ddee2d484159c6fda5ae1ee7d8beae517029b776e5250b5fda27"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "ff929e5e068babbef00d17b01c0c7fd21de40572da6afb09fd86682d38db1ed0" => :catalina
    sha256 "38c27cb1518f4a9392db30923905aff6699953a8dcacd5e7bb4cb57d06623e41" => :mojave
    sha256 "7c2ca014b2180796d059837204b96f5dc8493baccb1d44bd8fda6375c39f27d5" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
