class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.0.tar.gz"
  sha256 "f176f8356d6a3514c60956386260986ee3bc98f5111b1e2bcc83581bbed20f1d"

  bottle do
    cellar :any
    sha256 "3729f0d6eeb2fc4fd5ad04357c252fa12537b750679c1f5bc9077cfaa2ee2dba" => :catalina
    sha256 "32438c3c780e8f5c463273b2a10f396136f5841208f52337996e3cbdca5bdc88" => :mojave
    sha256 "8c739a44a8ea195b8e352bc6915fa086c77a078d6f98095f3d442d198af98c68" => :high_sierra
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
