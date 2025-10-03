class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.5.tar.gz"
  sha256 "3460d8a3e10a86e7fe0228d5d9abcda589713b8ed3ee007ce061ae01f8c2e1ea"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a1697db0c615f68049b055034beca20f3ebe94327c9976074176ef65141b89f"
    sha256 cellar: :any,                 arm64_sequoia: "754230b9132b8db3b75dc7eae342772e8e3cd3404e8bda89e0ca63a6bdab9333"
    sha256 cellar: :any,                 arm64_sonoma:  "8330dada267fd61aed38edb48579a83e57694c70c78b5c5c9064fd672983266c"
    sha256 cellar: :any,                 arm64_ventura: "0e7de121d382e0277e2d23e8627417493a97e8f7ca95b00f6bfc6b18a9064738"
    sha256 cellar: :any,                 sonoma:        "17b0aa7869f8977327c1ba0d5838fecc882dd85a3a6a6872806593f375ce0ad7"
    sha256 cellar: :any,                 ventura:       "614cddd90b7e738303e97d386fa1612ab57fd60766bf8fb8cc781af06adfde39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "527d6c7622d8df61721200858ab0e1eb2d538fb3e4742e19e1a7ab3ff3692c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a14165e0bb191f70ea0b083004328096ed866efa64e5b301ddd394c4df12d67"
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
