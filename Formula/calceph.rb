class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.5.tar.gz"
  sha256 "e1b9076b49fee51f7efda22194c8b66aaeebedbdb41d731c5af2cd0b16b39b56"

  bottle do
    cellar :any
    sha256 "d05d76368447fbaef129c9ffa993fb9e8ba948884c6b9409e2282953f887dbfe" => :catalina
    sha256 "4147bd6caffd7f2f03731420d9d2bf4db2123f9ce605a920630dca26ac711afe" => :mojave
    sha256 "ce583c86b55ca06a9c05b13e81fb096502e261513427c100f46d2c298a8bf98e" => :high_sierra
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
