class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.4.tar.gz"
  sha256 "20c9f0bd720c5cfe99a7b342babda3ff91428adfec9d55357b380b4a13205d60"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8052ae633e2e434f92a58297a7d95b7abf31c6df27a4f150f04acd90c458b24d"
    sha256 cellar: :any,                 arm64_sonoma:  "bccdf7dd4f4b833f7382eafad36ab00cc3e886f2193013fcf01f8c3edeab93f1"
    sha256 cellar: :any,                 arm64_ventura: "ed3e3aa4f63ba31eb8b56a313e7695c2bc1a1ec3f76b91de087ba1ba4c89c477"
    sha256 cellar: :any,                 sonoma:        "71acfca39979f054472b0f287a256e3ef51548f77e6e20410a3c669403a1b63a"
    sha256 cellar: :any,                 ventura:       "4527dfd754d1f940f46eca0af7000e6cb8f8c801521810288325c5e189eab35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cac5e4fa043c89c765556ecde72dfea4199b1f59f814840916c8c97eacc633f"
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
