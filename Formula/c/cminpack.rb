class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/refs/tags/v1.3.14.tar.gz"
  sha256 "10a76d214e01baa0480828fa473c2ef6209983c80941eca10b5a69df4de02cee"
  license "Minpack"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "740c8cacd9008730b5a0da0db01e2d4033dd8c2ff72b57419da8b441a16cbe98"
    sha256 cellar: :any, arm64_sequoia: "4f85045c1c6faa41933ba735e53dfc624f5921b2c47cf22144313e87ba0d3b7a"
    sha256 cellar: :any, arm64_sonoma:  "1479f4ba5bfc4d432ba2a635ad487af119b0bf2720ffb31ab2de4b108d247cf0"
    sha256 cellar: :any, sonoma:        "a2c39c087342b36d9a1b03e5947c7c3054473eab13f7ce54b74765a33365bd56"
    sha256 cellar: :any, arm64_linux:   "375802e4abc24ea040b7496c8f9ad473e825f5b76f2ad07e373ee25e70ef54d8"
    sha256 cellar: :any, x86_64_linux:  "c1edb8bfddef814fe0a5846696bd72e6c0a354b3c1baee04333e52adcddb1c6f"
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
