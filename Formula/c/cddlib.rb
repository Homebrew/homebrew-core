class Cddlib < Formula
  desc "Double description method for general polyhedral cones"
  homepage "https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "https://github.com/cddlib/cddlib/releases/download/0.94n/cddlib-0.94n.tar.gz"
  sha256 "b87ee07ba2c1d0ab92a3e4eccacdf568f981a095a392e3b9efd7e7e4a9e125b1"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d689cf16077c6e02f851c4d2a45b73539c9ad2eab766ab75cbf3ab7c21b50267"
    sha256 cellar: :any,                 arm64_sequoia: "ac504ee11eb267b9968a1ea970356608880054457bfebd24f18820b1dc6010a1"
    sha256 cellar: :any,                 arm64_sonoma:  "afc609fa9a3560208e7441ad073a6959aa9f474483016b8aa5be9aef8a65ab0b"
    sha256 cellar: :any,                 arm64_ventura: "368d7e7af37feb06abebe16bebd54583353543abe5be0d57290c9f9ae96e3bbb"
    sha256 cellar: :any,                 sonoma:        "e202144c2c75c4e40345c13eb02b22ea80fe6177b91fd5bfd04ad5546f19c351"
    sha256 cellar: :any,                 ventura:       "24fc8bc926b2943d0ef8b447a76cc4d0facbd52a4e9691b20272b748b272484e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30e583fcfb964d44dbad623186b1fe4e5376711d0b911bcc3ece78148878db07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc67a9e27992e7053430117534a76f2fce8ec8f91aad21418bc85bbdadd8fad"
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/cddlib", "-L#{lib}", "-lcdd", "-o", "test"
    assert_equal "3.66667", shell_output("./test").split[-1]
  end
end
