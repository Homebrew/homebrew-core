class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://calceph.imcce.fr"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-5.0.0.tar.gz"
  sha256 "aea5120af73f0a492cea2fdc9c63078ee5b625a181cc4f0622ffa68160a2d20b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6eee07b5e3eb9ffe17467f1d4e002607ebcbd0e6240ff17db45d613713550e2f"
    sha256 cellar: :any, arm64_sequoia: "bd0abe2d6c82207fee9edd8d265c05c6dc91b5694a118f487d5ad887d328cf5d"
    sha256 cellar: :any, arm64_sonoma:  "f29c80e99a4b49893a5c78e6e7584ea2a9cf3953b67f2fedc0b406612df34d51"
    sha256 cellar: :any, sonoma:        "c9acd7c2ef7a11e54ea48c48781315682428c5633d573a19aab81ca8d70f437b"
    sha256 cellar: :any, arm64_linux:   "41840ebcd20d272037f2623f108ab1bf27d4001773d57865a6224e7e8f51906f"
    sha256 cellar: :any, x86_64_linux:  "b42bb590fb5819332ddad034a2ea82d997bb08158d0fb2bf8fec1c2c4686e950"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    # Fall back to gfortran's mangling if Fortran/C interface detection fails.
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_FORTRAN=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFortranCInterface_GLOBAL_CASE=LOWER
      -DFortranCInterface_GLOBAL__SUFFIX=_
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testcalceph.c").write <<~C
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
    C
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
