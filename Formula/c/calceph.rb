class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.3.tar.gz"
  sha256 "9dd2ebdec1d1f5bd6f01961d111dbf0a4b24d0c0545572f00c1d236800a25789"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aaabf19a88946b281b82c80f55a7b2540f9495a51a2964bbf4e4da45ed1829b7"
    sha256 cellar: :any,                 arm64_ventura:  "c26c4cb6eba9c5dc6d5144ec75aa649c64af8d956feb56ad0968168608cb7e24"
    sha256 cellar: :any,                 arm64_monterey: "c1f882709bc71c3785109466e41e7e2828a79a866190160d781a95fd40a36c38"
    sha256 cellar: :any,                 arm64_big_sur:  "21265e292c3ba49e39265ce3084bce1afb07f1908911df4d61a80e70c2fadb1d"
    sha256 cellar: :any,                 sonoma:         "391675fa0bf6d18d7afccafc2ba08f53cade9786ab5e4ac2aaebc4089505afe9"
    sha256 cellar: :any,                 ventura:        "2d09dfe20da47d176f40a7ad06e76ee8fa9efc597b57983332e1343e6c331851"
    sha256 cellar: :any,                 monterey:       "c7935ce0cf39131e1c011d29ba2180a0b86dcbe622e7f00e81e6032737ed01cd"
    sha256 cellar: :any,                 big_sur:        "543c2da4f31607e18b6a20842d093726240c96ab04dfccb5f1c028810aff8387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed60de55e289c40d049b74a19a3a5065adbb2428f25df172e1dea3285bf78f0b"
  end

  depends_on "gcc" # for gfortran

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

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
