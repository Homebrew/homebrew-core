class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v3.0/libcerf-v3.0.tar.gz"
  sha256 "c6108fbda89af37f588119c0c542b6c1e824845a36bea2fa31f7ed2cc1a246db"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "093e9b7e5a294c1064d174f62b4a17e09bfb57f0fe2dd97b8b6091cf9e6d4ff6"
    sha256 cellar: :any,                 arm64_sonoma:  "8abb6bed129a07ae4601cd1bd84f1c4c062ad8eca2bdb15ea3fa33c1dd8e8f39"
    sha256 cellar: :any,                 arm64_ventura: "05f13dcf138876b29e6a9ac49b356ee1afdaae3671a19973cdc6688b73f1cc07"
    sha256 cellar: :any,                 sonoma:        "d1f71ef6427fe87f8c1fca1ac83ff534a4b01086ae8835d8b14c2ea72710c97f"
    sha256 cellar: :any,                 ventura:       "52409e3c2993db96a2edcb1a9229530fb9b5d1f3375c1dfafe18476ccb087e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b2e39bf56ebf87f61fdb69caf20157ee0c20f1f55d0c57cd5676de672969ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1181cfb82445d2b1fb89fbc80a2337d598ce59d8f71e9159344851eb05288e9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
