class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.10.tgz"
  sha256 "6a412c13e404411d77105c731a756384970424d6f65d1c4c63758c28183d4b61"

  bottle do
    cellar :any
    sha256 "b3db64e3c15e5b82bda685d1288b3520d357c86a596c6d4f30c90c5f2b3eeeba" => :mojave
    sha256 "76e4bb145a292d03277d0a2543130f67b780e4c2de686ff1f7485db1658af2af" => :high_sierra
    sha256 "726a3ebfa87404a2376da3b8209fd2541b9e13a7bde43a224768beeb2dcac591" => :sierra
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
