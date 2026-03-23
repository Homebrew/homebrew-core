class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.11.tar.gz"
  sha256 "45675fac0a721a1c7600a91a9842fe1ab313069db163538f2923eaeddb0f46de"
  license "Minpack"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf36741d02460936e3bb3dd0819e61ac8a3c2645d177c8fc7bbe64cc10583b88"
    sha256 cellar: :any,                 arm64_sequoia: "a3742c503095e979488e41caa028da813433223e16d138233a03b6a50566c8fe"
    sha256 cellar: :any,                 arm64_sonoma:  "6e56f9a0fa73e882dd63c5cbbb06f5fbe27db19fef627207cc5d253db3b4ccd0"
    sha256 cellar: :any,                 arm64_ventura: "ba4c53b942a58d25cca56a66bc8b66383042b4fc675bacd71e07a88257035818"
    sha256 cellar: :any,                 sonoma:        "fb0d98cea9e085b73c79cd908d32e853f2eed59ec62bed48fa75ea2c5695fa7e"
    sha256 cellar: :any,                 ventura:       "86f126b5834472ae2a8db9c866c2e3233b9b29551d50a6df956015b0b8f16745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ceb2a64c3d2be1e1fdec4a80fb793d1ee1cca486edaca6d0070d8865f7e244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f55468bdd04566bbf3e98f914a13aab28e016a20f3f80c63804159611f9997"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
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
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}/cminpack-1",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    system "./test"
  end
end
