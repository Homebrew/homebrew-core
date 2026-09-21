class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://calceph.imcce.fr"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-5.0.1.tar.gz"
  sha256 "923d5db2fca10636b64e5529552edf1de8bd3da1da3cc7ac963ae6c3895a31ae"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82950772ec0dc121bac775e5430730da451dfa429b14e36cdc85ecf273d18b27"
    sha256 cellar: :any, arm64_tahoe:       "5f9ee625bfc6da755cc6747e51b330dfae42478d1f580e3ed05871df08fdfb77"
    sha256 cellar: :any, arm64_sequoia:     "f575faca305766338278980c758e8bbdfd660a90dcaef6f51af5d8a644ebca6a"
    sha256 cellar: :any, arm64_linux:       "331fba5627f656977c3f17525f395a03bb9e6334f287bd3e8a986280855f0b22"
    sha256 cellar: :any, x86_64_linux:      "2906c6e83b3630c189d1caa84c4e8f5f237c483b1e7c6bf7726d9e12b3da22bb"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?
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
