class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/2.0/libcerf-2.0.tar.gz"
  sha256 "9461f7fa38a666f13eaea888322e797d1bfb3ef9d923131d7cd723298aafaee9"
  license "MIT"
  head "https://jugit.fz-juelich.de/mlz/libcerf.git"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any
    sha256 "d1be9525402c49ed718ae3192d0990be1964428f740dd76812db78cbc7225037" => :catalina
    sha256 "9027ca30f7747171aba44efcd83cfbe65f5db46441077b143a6c2cdc23bcffa8" => :mojave
    sha256 "2551e26f4b79121e409a411901585d8aff3348921ba42e75e9947824962ac8d0" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
