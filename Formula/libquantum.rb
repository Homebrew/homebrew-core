class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.1.1.tar.gz"
  sha256 "d8e3c4407076558f87640f1e618501ec85bc5f4c5a84db4117ceaec7105046e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f815ac5226452dcc0de65c72ab31e647c99af2f6e1ceea7af3022069632c625" => :catalina
    sha256 "0a74bf2e856af7db63821d9ed7fbbd569977c04f808d52380fe841ad1e855cac" => :mojave
    sha256 "3e5896712c2c1a35d230aad235f312eac36946fbac1f605e6c5b90963c6c22c2" => :high_sierra
    sha256 "ac518e4460bb259e294f1eabbfeb85c9e996ccab05f6e97a915ec34d21ae4e5f" => :sierra
    sha256 "14c3e392521c20d45a993639de7f561bc0d2b2718158636074bac6f0a2d41581" => :el_capitan
    sha256 "ce31c2a7df81599bc4930ad4aef206f22e006db41d32d05ef1f2f3e72ff6d29d" => :yosemite
    sha256 "2347b6f64ac6a2463cded1679de4390f5bda4b07a74f304efd4ea3bc536af3df" => :mavericks
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
