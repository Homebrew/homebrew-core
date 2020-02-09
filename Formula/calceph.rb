class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.2.tar.gz"
  sha256 "4bb95979ed77f431c6845b11b7bc49819836e47a8b9ceceff18309683f580c5b"

  bottle do
    cellar :any
    sha256 "5e4206546ab06f2be6cdd374875f0f4271d9c6bae47d9e8b34c5107bf42fb5a0" => :catalina
    sha256 "651404e772706253e5d89ac64a20e91739a986f31cb021d5f2332589be9ca7fb" => :mojave
    sha256 "1fb02d36ea82a01148a23c8613be09489362380646b14468060fe347a78c18a7" => :high_sierra
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
