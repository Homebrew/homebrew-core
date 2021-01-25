class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org/"
  url "https://github.com/concurrencykit/ck/archive/0.7.0.tar.gz"
  sha256 "e730cb448fb0ecf9d19bf4c7efe9efc3c04dd9127311d87d8f91484742b0da24"
  license "BSD-2-Clause"
  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha256 "2834fffaf1b10eb3ee40fa9f01bfbe72a5df37161cbf78f8dd016f73aaf16966" => :big_sur
    sha256 "fad8ab6678349a6ae3a81ba7a8264591868f8c180c867f06ad98cb422d9627bf" => :arm64_big_sur
    sha256 "12788eda54c82375102f2f33e28f533151b4d3f6fa9042ea7c7aa03fb25c3e3a" => :catalina
    sha256 "357062d84adf8f0c8d1a92a7fda6fb9278b6264edf061935d595342e0c334aed" => :mojave
    sha256 "c8def7655e173d45ff8ec94bc78750507235fa9eb8b79be639bf250698d59761" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ck_spinlock.h>
      int main()
      {
        ck_spinlock_t spinlock;
        ck_spinlock_init(&spinlock);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
