class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.1.tar.gz"
  sha256 "af120397ab185fc77a60e1656a433a12b7fc17d501961463079980c837f9e73e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86dda990eb2371605d6378b49c8855867160a42d5e9a748a7b86e331c5d099ec"
    sha256 cellar: :any,                 arm64_sonoma:  "699d33f616c458b193fb12c680aa65b0d060b987e1d5c48cb4d38fb0b7d31874"
    sha256 cellar: :any,                 arm64_ventura: "d27ebb8de0aebd22c6121a67e569a110d60a2cf4ae86f458d47218883a570963"
    sha256 cellar: :any,                 sonoma:        "4a2dc1bee8058fd4f55fbf7dc294f809401201eb39ff4cdbf087fc936280c90b"
    sha256 cellar: :any,                 ventura:       "adafa443652f78b756259092dc4ec747e5801b6d363e065f5a20367fd5adc5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266e84d10ee2a143ecbabfc0282d8a1a3f40e5f6e54d45b6bed8a15ea88ef1f5"
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
