class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.15.tar.gz"
  sha256 "4bcc2fb514809eaa7bfecf2f2f663f3f0988a425ff64615316f5c4ed68757b97"
  license "Minpack"
  compatibility_version 1
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5c3b2e9fe67aa283195c193431b8ae141856e41948755b8f5478e733ea547184"
    sha256 cellar: :any, arm64_tahoe:       "c6e7ac92386ae7ab658b6f9f422dfd11da82e39113a803308984fc77e7255f5e"
    sha256 cellar: :any, arm64_sequoia:     "1757084529d88dfad798bc6041453dda44e8c07f6b8c0cd953f64ac126c76dd4"
    sha256 cellar: :any, arm64_linux:       "b323456f5bcf44bb111a135c09c757feb8fbaede96134991da9ce5e242f02879"
    sha256 cellar: :any, x86_64_linux:      "0c3aa3236b2dfad9a1e71ed70875ed802d126ac36e61aa7ad3a58200ea43f0c8"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMINPACK_LIB_INSTALL_DIR=lib
      -DBUILD_EXAMPLES=OFF
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
