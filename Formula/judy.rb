class Judy < Formula
  desc "C library that implements a spare dynamic array"
  homepage "https://judy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
  sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <Judy.h>
      int main() {
        PPvoid_t judy = NULL;
        Word_t index = 10;
        int ret;
        J1T(ret, judy, index);
        return ret;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lJudy", "-o", "test"
    system "./test"
  end
end
