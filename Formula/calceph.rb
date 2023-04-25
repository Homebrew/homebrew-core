class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.2.tar.gz"
  sha256 "e43ab9b2750fda3598899602851bae182f11c415444c22d753409218a3a2d2e6"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c01c0ff6df3c1bbc1f8bad4ff68b1bc0ea76a3eb8ca76d1d6e9faae52d7f11f1"
    sha256 cellar: :any,                 arm64_monterey: "d5f228f651131e89c399733aeff67ebbf1df7a812963c345c7194d7f9a5ceacb"
    sha256 cellar: :any,                 arm64_big_sur:  "58a42fa91f7863eb3fcd174332387d8b247739cb3f65f40dc8c5714186fa18e4"
    sha256 cellar: :any,                 ventura:        "93e3f7ee780ae17bf087d21067fec3d78905c4bb0fe60bbd5c140f4cbffcf356"
    sha256 cellar: :any,                 monterey:       "daf8fb2630eed6d2d357f31b8b2b2cd631ff7672ce23e7223a24bff07cf9db00"
    sha256 cellar: :any,                 big_sur:        "cb7eb19af6792c9fbc414162d31fd20b087b8537a6d72f94ca65a002ef85beee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983ddb9b99f9a920970954d9e2c40073ffdfc658c73b00247fe04ede26a3cf0a"
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
