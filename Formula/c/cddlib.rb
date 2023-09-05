class Cddlib < Formula
  desc "Double description method for general polyhedral cones"
  homepage "https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "https://github.com/cddlib/cddlib/releases/download/0.94m/cddlib-0.94m.tar.gz"
  sha256 "70dffdb3369b8704dc75428a1b3c42ab9047b81ce039f12f427e2eb2b1b0dee2"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "768fd3254daf99ec710427f4f36f42ebcce984d14168684a633e5a86fe4c8c92"
    sha256 cellar: :any,                 arm64_monterey: "dc6b3a52efe03676d1d97d2c70b3bb7d7f09bff623f13f259c2afb2f0d247704"
    sha256 cellar: :any,                 arm64_big_sur:  "a6cc39c5866ef92484b20b3e4fa71916e4fe02f91314f5a90e64a8ac6d477f5e"
    sha256 cellar: :any,                 ventura:        "d58420dfada364570f86deb3f6aca808f9de5ffd905e67f51473fd7e653ec570"
    sha256 cellar: :any,                 monterey:       "06ea555e6166ee528da1ebb86ba65dabf584d472ee7ebcdb5abb59f5dfe2381a"
    sha256 cellar: :any,                 big_sur:        "2d9ded9039be48632f55065ccc0cac90ee53bb41e9a900bd955997ae113eabd8"
    sha256 cellar: :any,                 catalina:       "3e3369de96b6c33641ec2c5a3e490afb72ad94b6fb913385f574089ec4b2b0be"
    sha256 cellar: :any,                 mojave:         "362934e5d50dc994ce268a690706d6950f17e1b191f315617adc0eeacc0b51b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbfdb16a069a1c098e379da5b3f12c461f639f09f36addc65e5f07f27e1f1e9"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "setoper.h"
      #include "cdd.h"

      #include <iostream>

      int main(int argc, char *argv[])
      {
        dd_set_global_constants(); /* First, this must be called once to use cddlib. */
        //std::cout << "Welcome to cddlib " << dd_DDVERSION << std::endl;

        dd_ErrorType error=dd_NoError;
        dd_LPSolverType solver;  /* either DualSimplex or CrissCross */
        dd_LPPtr lp;

        dd_rowrange m;
        dd_colrange n;
        dd_NumberType numb;
        dd_MatrixPtr A;
        dd_ErrorType err;

        numb=dd_Real;   /* set a number type */
        m=4;    /* number of rows  */
        n=3;    /* number of columns */
        A=dd_CreateMatrix(m,n);
        dd_set_si2(A->matrix[0][0],4,3); dd_set_si(A->matrix[0][1],-2); dd_set_si(A->matrix[0][2],-1);
        dd_set_si2(A->matrix[1][0],2,3); dd_set_si(A->matrix[1][1], 0); dd_set_si(A->matrix[1][2],-1);
        dd_set_si(A->matrix[2][0],0); dd_set_si(A->matrix[2][1], 1); dd_set_si(A->matrix[2][2], 0);
        dd_set_si(A->matrix[3][0],0); dd_set_si(A->matrix[3][1], 0); dd_set_si(A->matrix[3][2], 1);

        dd_set_si(A->rowvec[0],0);    dd_set_si(A->rowvec[1], 3); dd_set_si(A->rowvec[2], 4);

        A->objective=dd_LPmax;
        lp=dd_Matrix2LP(A, &err); /* load an LP */

        std::cout << std::endl << "--- LP to be solved  ---" << std::endl;
        dd_WriteLP(stdout, lp);

        std::cout << std::endl << "--- Running dd_LPSolve ---" << std::endl;
        solver=dd_DualSimplex;
        dd_LPSolve(lp, solver, &error);  /* Solve the LP */

        //dd_WriteLPResult(stdout, lp, error);

        std::cout << "optimal value:" << std::endl << *lp->optvalue << std::endl;

        dd_FreeLPData(lp);
        dd_FreeMatrix(A);

        dd_free_global_constants();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/cddlib", "-L#{lib}", "-lcdd", "-o", "test"
    assert_equal "3.66667", shell_output("./test").split[-1]
  end
end
