class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v3.2/libcerf-v3.2.tar.gz"
  sha256 "ea8d110d73ec24a643042ca3940461ccbb1b6541e21310ecb70ab4e4dc144aef"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "main"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "720c3879f7cdb5616e52b59a0fe1c07ae7640fe1fbccd6991899764d0fd23c79"
    sha256 cellar: :any,                 arm64_sequoia: "326da55ffe3d73821eb6e9529c6725a4e9d628fc225fa191e7a1a1c9bdfcba80"
    sha256 cellar: :any,                 arm64_sonoma:  "702f64e9b53853bda6fb5e878fa2f024e71f8d8111df320214ae26e909d8240d"
    sha256 cellar: :any,                 arm64_ventura: "bc4a6f8d1582ee0fa548405c4d0e1db16dfdcd9765d5249b2f208cd338d3b7c4"
    sha256 cellar: :any,                 sonoma:        "6eceb833299516b1fbdf541e2bda038fcc8ec8e4008123df7e764e6a639b80ec"
    sha256 cellar: :any,                 ventura:       "b717f5e843f27c34950c31f50c48f9a5b0a6990619b01ffebba379ab74a7e803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b1cf8ec6e31f85bd855b68ea7ae07d297acbbd159a5f12f675153fa906f622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3400787358dc650401ceb2549f726cdad058826ee305f1056b59d40ff38e2b08"
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
