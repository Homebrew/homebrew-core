class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  url "https://github.com/fplll/fplll/releases/download/5.4.0/fplll-5.4.0.tar.gz"
  sha256 "fe192a65a56439b098e26e3b7ee224dda7c2c73a58f36ef2cc6f9185ae8c482b"
  license "LGPL-2.1"

  bottle do
    sha256 "3683b4c40387324054f6eb43ee129cd28cb7107e21cab7425b9da5fc1834578f" => :big_sur
    sha256 "9818320e953a6a251958ee097350481f86952bfac55e9f8219ecac92071738fe" => :arm64_big_sur
    sha256 "de1d71773f6fe6baaf83e6b7c8cbc1521842854536242482a35b70b1c37a4b7b" => :catalina
    sha256 "dc27cc471e40516aba9bd490813f5853a9fe326ea490ee27f6cf57f5c916f1fb" => :mojave
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
