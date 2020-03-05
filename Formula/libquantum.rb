class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.1.1.tar.gz"
  sha256 "d8e3c4407076558f87640f1e618501ec85bc5f4c5a84db4117ceaec7105046e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a58575e3f577ad9f8157546913669bac571462dd34d32e54c37e2935b126bed" => :catalina
    sha256 "0c7724330a9a2741d5b52521482fb4c4516d5dc7115538f6131894e4d2b31e10" => :mojave
    sha256 "1a93bf4fd93f8a68412b622fcf94eddd2fa9a86ada64dd8eb4cca27ccfaa8ce1" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"qtest.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    EOS
    system ENV.cc, "-O3", "-o", "qtest", "qtest.c", "-L#{lib}", "-lquantum"
    system "./qtest"
  end
end
