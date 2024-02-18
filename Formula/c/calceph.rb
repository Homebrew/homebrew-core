class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.5.tar.gz"
  sha256 "f7acf529a9267793126d7fdbdf79d4d26ae33274c99d09a9fc9d6191a3c72aca"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6caee108ddd6a6510998c572929ffd950f76040c267788098b8a117ec0197fc6"
    sha256 cellar: :any,                 arm64_ventura:  "f003f9a8037eace25bc98d659a3afb8776669278da4f1928a5976965c8035ab3"
    sha256 cellar: :any,                 arm64_monterey: "cd5dbd77c1e6989284f95239c1327cdef01bedb1706bc756544518b003a3f27e"
    sha256 cellar: :any,                 sonoma:         "f55f8ccf745f4815d92a193b699d296f7c0a14b860048f482b50b9454739f738"
    sha256 cellar: :any,                 ventura:        "cf5a9ff7639306750dc9996946ab150dee3d08c967a64e463c25a3959ee334bf"
    sha256 cellar: :any,                 monterey:       "080c50596ddb83e1741018175e8219419f57bddfc2a72201d7285b5a1b58d0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d889b6e08767bd3c7353cfc85d075e5c6bb181ca33220b64809cae1c303be09"
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
