class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.1.tar.gz"
  sha256 "4633f3d2ee4818e172a2da3c357b6e4103bae029250c0a12f119ee12a10f4812"

  bottle do
    cellar :any
    sha256 "f10f53e74dd2c957ec823de213f5d6476cb198d5e87c67893960486ba470efe5" => :catalina
    sha256 "067c007d33fda94557b0bd366cc2c7cb9229a919af0417fde45344b5b4e98fa9" => :mojave
    sha256 "1f05ad060dcb241df0447510514c7a4892d60c88fdfa8513503967d87be397da" => :high_sierra
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
