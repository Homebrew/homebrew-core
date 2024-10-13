class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.5/fplll-5.4.5.tar.gz"
  sha256 "76d3778f0326597ed7505bab19493a9bf6b73a5c5ca614e8fb82f42105c57d00"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_sequoia:  "8b425ebd95749e2547ab4fd07cce428ebe24b53c0313613d3ae79e4884714e8a"
    sha256                               arm64_sonoma:   "005ede2a59af2f7cca112eae17a3128cc51655e87b94f32d99cc419370e84f8a"
    sha256                               arm64_ventura:  "b6cd7be6eff467d3232377783aca10e2f233550ac3d41e50731e78fc3d7bd528"
    sha256                               arm64_monterey: "0e4d84d3652a61c6276ae3514062702c6d908eaff1ebca50942a9c20c73112dc"
    sha256                               sonoma:         "3894a53bb67520e1917065140d56bd920f86a550d3ba9a04c2e79caf7df74b97"
    sha256                               ventura:        "9880f878b0569d0bb86363a9cc3a46b4b4688bd48b2f8b4fb8cf25e1b2d20039"
    sha256                               monterey:       "f23ce17d986fa034eb47fdb832a32d7c1d01482cd289876547ce830062386595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5384ba66202662ce80e4a5d644a6e2f1f38a6432d4b1a772b716428553ce2ae3"
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :test
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"m1.fplll").write("[[10 11][11 12]]")
    assert_equal "[[0 1 ]\n[1 0 ]\n]\n", `#{bin/"fplll"} m1.fplll`

    (testpath/"m2.fplll").write("[[17 42 4][50 75 108][11 47 33]][100 101 102]")
    assert_equal "[107 88 96]\n", `#{bin/"fplll"} -a cvp m2.fplll`

    (testpath/"test.cpp").write <<~EOS
      #include <fplll.h>
      #include <vector>
      #include <stdio.h>
      using namespace fplll;
      int main(int c, char **v) {
        ZZ_mat<mpz_t> b;
        std::vector<Z_NR<mpz_t>> sol_coord;
        if (c > 1) { // just a compile test
           shortest_vector(b, sol_coord);
        }
        return 0;
      }
    EOS
    system "pkg-config", "fplll", "--cflags"
    system "pkg-config", "fplll", "--libs"
    pkg_config_flags = `pkg-config --cflags --libs gmp mpfr fplll`.chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
