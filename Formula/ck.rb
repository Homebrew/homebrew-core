class Ck < Formula
  desc "Concurrency primitives and non-blocking data structures library"
  homepage "http://concurrencykit.org/"
  url "http://concurrencykit.org/releases/ck-0.6.0.tar.gz"
  sha256 "d7e27dd0a679e45632951e672f8288228f32310dfed2d5855e9573a9cf0d62df"

  bottle do
    cellar :any
    sha256 "29ded4898ebd1f8dfa7fc5adb377a7b3404b8a9c1d11db5ab2e85c3cb6f62ad7" => :sierra
    sha256 "4e74455ae32382c6eb1b7077d1166e72c2d1f8f66c5c74fc0fc975323c6e1e40" => :el_capitan
    sha256 "c01c837e8999093e50cc565681fe22436289c0cbd5bed288d758fca95f414622" => :yosemite
  end

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
