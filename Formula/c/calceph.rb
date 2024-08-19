class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.0.tar.gz"
  sha256 "f083df763e3d8cbbd17060c77b3ecd88beb9ce6c7e7f87630b3debd1bb0091f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f3eaa36769c57dc20c5b7d0f16deeb6b45ed5c68f3f58630c727225e5d4ff586"
    sha256 cellar: :any,                 arm64_ventura:  "3ce78bef643795814bbcb10893afecf503f1b01f08534f6aa051d0bb3a27083e"
    sha256 cellar: :any,                 arm64_monterey: "eddf124a142143cec2c295f7f72577465a2ddea36d572d8b7042e940ed4753c0"
    sha256 cellar: :any,                 sonoma:         "e57374f3abf1844e583e041d96cf9e96326db74ce07b6f03f21e16a609b9fc5c"
    sha256 cellar: :any,                 ventura:        "c8433423489014bde56b59e9cacca52de5e243989c1609ffa5b9d1dbaef8c7f8"
    sha256 cellar: :any,                 monterey:       "f81b50297c00919226302bb6441af824b2f63466530ad73e7f2b76e9de9732d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ca2fed126afa7575352d456b0e7c6fef6b5a4274ddf1b2607d7347c4434edb2"
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
