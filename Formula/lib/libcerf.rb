class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v2.4/libcerf-v2.4.tar.gz"
  sha256 "080b30ae564c3dabe3b89264522adaf5647ec754021572bee54929697b276cdc"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f98b11354a3acc473bd2697aa55845991c99f4e94577882a63a2511c00f6c703"
    sha256 cellar: :any,                 arm64_sonoma:   "34b1ea071894550defd96682761ad9a6e9b9df19ac66ce5e0541bc5f82267946"
    sha256 cellar: :any,                 arm64_ventura:  "b3b61822329b217da59ae7255dda43a504ac83256f6fa0ac8420317a2d73c339"
    sha256 cellar: :any,                 arm64_monterey: "ded6d40e220e6e5258f589f36172ad6e0ddd110b1a38134dca1676b7db43f089"
    sha256 cellar: :any,                 arm64_big_sur:  "939d2020151a7061a1615ff87b841121662d6be8d6441eb5e41beac6586b9625"
    sha256 cellar: :any,                 sonoma:         "449f2996aa67026fab6fd8e70068d78d507f3855c844274b01757015de16d364"
    sha256 cellar: :any,                 ventura:        "24d10b02769be590e55fca864a080e13fd0def7f2b655a5e0f0861393d036f22"
    sha256 cellar: :any,                 monterey:       "5338caa2b9422debd382f920fef79a1f0acaedd843ab3924905cf332df708144"
    sha256 cellar: :any,                 big_sur:        "237d8d549c7bfc15d7d770eff70cfe3df04fe264b156f63bc156ac1a9ddf52a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24d01493cf36431018586ecbef6ad3d7a14837e257188d0f78d18f4c0f77113f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
