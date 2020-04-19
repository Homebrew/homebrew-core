class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.3.2/fplll-5.3.2.tar.gz"
  sha256 "4d935d712d11902c60a2a5cb50b696391f4ca4a2de59b0daeca74c29024c21fe"

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
