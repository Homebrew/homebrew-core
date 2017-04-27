class Ck < Formula
  desc "Concurrency primitives and non-blocking data structures library"
  homepage "http://concurrencykit.org/"
  url "http://concurrencykit.org/releases/ck-0.6.0.tar.gz"
  sha256 "d7e27dd0a679e45632951e672f8288228f32310dfed2d5855e9573a9cf0d62df"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <ck_spinlock.h>
    int main() {
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
