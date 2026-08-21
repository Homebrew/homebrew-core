class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/lib/cerf"
  url "https://jugit.fz-juelich.de/mlz/lib/cerf/-/archive/v3.3/cerf-v3.3.tar.bz2"
  sha256 "ea9ec1e114227d7d90dbf7985c8801d8ac00e2b696a45dd1058b40e80f283882"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://jugit.fz-juelich.de/mlz/lib/cerf.git", branch: "main"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9a900691ec484b5b208be703da7a5f9035c89c7a075b3a4bad56fbe5ab4e96f1"
    sha256 cellar: :any, arm64_sequoia: "b7ff62cbac27ee100bb1fc7f0eaac9d4c3d0f9ec42b61db74e6ac365888b6539"
    sha256 cellar: :any, arm64_sonoma:  "fa67893d311bf0ab0bb33b6c9e9db123665469451745e94a7b2ac8528c30b23f"
    sha256 cellar: :any, sonoma:        "a7f380e212f00145f031f37500d46679bd5d153d39b6d09c50a11db8af1c47dd"
    sha256 cellar: :any, arm64_linux:   "3ac71eb77e20d7bc5884e93179ef635e9391775fcef01cf80264850c6b4338db"
    sha256 cellar: :any, x86_64_linux:  "9456b1c6425be1138bc4546603cd569415bb4d2b09d02467920e0a4deb1646c6"
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
