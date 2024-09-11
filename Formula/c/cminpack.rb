class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "6355776f60ebfeef63883aa02c19ab57f1ba776e43122f27cb3161e7fc277d1d"
  license "Minpack"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "86bc67892d2e77b412e515a3598ce1eaff543a6332b3a6790991f1097f21c031"
    sha256 cellar: :any,                 arm64_sonoma:   "0e5f0c2d803c0654badea5b1190cf902b1195ddc44f8208cf2113449c07f287d"
    sha256 cellar: :any,                 arm64_ventura:  "f94482365bf6b246bd83f4bd64fb8c0db55a6604e28d742f391a0e3909b9d979"
    sha256 cellar: :any,                 arm64_monterey: "d040255d38ec193f4597e283360372b590d9e252f47aaf6e58c70cc386851685"
    sha256 cellar: :any,                 sonoma:         "55d1709b8309ee871f69e4cc7b4fc905f122f71dfb187fd42d2f7bd5ba539514"
    sha256 cellar: :any,                 ventura:        "5c23a7d0b2540058345752725d4c9f7a35d2509102b23af4494ac8a91ea361eb"
    sha256 cellar: :any,                 monterey:       "5e63db34b0679bfc8f9798bbc43b69c17cebdfd4205025b9744b0e1df1371920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f911f0918c2671e382f5421d0c443075c46deb900947fbb241fb088060c1c0d"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  def install
    args = %w[
      -DUSE_BLAS=ON
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMINPACK_LIB_INSTALL_DIR=lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man3.install Dir["docs/*.3"]
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cminpack.h>

      int main() {
          int m = 2;
          int n = 2;
          double x[2] = {-1.2, 1.0};
          double fvec[2] = {0};
          double fjac[4] = {0};
          double tol = 1e-8;
          int info = -1;
          int ipvt[2] = {0};
          int ldfjac = 2;
          int lwa = m * n + 5 * n + m;
          double wa[lwa];

          for (int i = 0; i < lwa; i++) {
              wa[i] = 0;
          }

          info = lmder1(NULL, NULL, 0, n, x, fvec, fjac, ldfjac, tol, ipvt, wa, lwa);

          if (info >= 0) {
              printf("Success: lmder1 returned %d\\n", info);
          } else {
              printf("Error: lmder1 returned %d\\n", info);
          }

          return info;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/cminpack-1",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    system "./test"
  end
end
