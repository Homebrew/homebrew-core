class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.2.tar.gz"
  sha256 "73a3ffa211dfc4a4a5b789e758174440661afb6dccb6069650d5bdcb42f579f7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f24e5cea5cc42ec9bed77b7d4b0b42ec391721819dd844b875b846661498335c"
    sha256 cellar: :any,                 arm64_sonoma:  "0c52786d08c6110c6a9bc161ae32ed3540febad113039d7a40801b3883a048af"
    sha256 cellar: :any,                 arm64_ventura: "365aea609423d29301fa76b57c4208ffa3f8f7f5ee67522167534118f396edd8"
    sha256 cellar: :any,                 sonoma:        "56132596693c90bf692acf758c4eb972db95568050e7034818712df642c61e2c"
    sha256 cellar: :any,                 ventura:       "1c8e824b5557f1e1b15419ed6a06271e420c39fbe733bdc5dd53fd49642b4e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a78f90763f5da5a66e953b6c15b7d298ef12f6d5a284da7d1b2eb3570af2a5a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_FORTRAN=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
