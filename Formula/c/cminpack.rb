class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.13.tar.gz"
  sha256 "cf0d6cc654f8c63bb65979056ea5bcda1046768b1dfe83ceda504924d8331167"
  license "Minpack"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eecfc8ac9b2291672cf63ecf8470ad6b4d5ff4396737836a96b65856d57fc31d"
    sha256 cellar: :any, arm64_sequoia: "22c587f67849d49cd0aee8011004a0c7e18b0ca340f7543d4a35bb9852c965f1"
    sha256 cellar: :any, arm64_sonoma:  "361be92f6d7519ab991a27bbb102080c896d9c79ff26d179def636645c088432"
    sha256 cellar: :any, sonoma:        "19e912e98e74a6e655eb67a930c2b8196a4c7774b7368845a070e10998d37f52"
    sha256 cellar: :any, arm64_linux:   "3f82e82188e615da3edd9fc73e590fbbfb53ba32866704f3106f5684b5fd4196"
    sha256 cellar: :any, x86_64_linux:  "77295f1b54e711f1269b5f4ef9054b79a7f783cd7afe69a536a26ad11ad756b3"
  end

  depends_on "cmake" => :build

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
