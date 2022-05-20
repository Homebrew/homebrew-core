class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.1.tar.gz"
  sha256 "33cc0be1b8ffb647aff9d3ac1cf025e460451e00144050d3bbc4f13bceb11c1d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d57b2878163732d50d7bbb920d7d1a4ffdb18f5a3e6a2b6d066d40f169316d5"
    sha256 cellar: :any,                 arm64_big_sur:  "0f3762cdf0a7d25f268340f36bde4cb4963ed8d472c82e83e217506f84a83433"
    sha256 cellar: :any,                 monterey:       "fd5bb3cad77f4e9e7fc4488cb812d7d5fb45fa0e25c97baeac488cf610d75fbb"
    sha256 cellar: :any,                 big_sur:        "353dcab7ad416277151c61feefcf673d25bb4f952aaaab3df6ead34a9828ab24"
    sha256 cellar: :any,                 catalina:       "5856594c37d877e282d9ba9ffab5789628f15a4252f506ae231d7dc8a7fb9f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c00da491fe489ea4e7a4a3013b62d26e16c49e1c248db2f2725272bc788f43e"
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
