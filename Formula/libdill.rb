class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.5.tar.gz"
  sha256 "896c82f47597ca1643f776c0141c4e352582d8739d1628caa2e406a1070c92f4"

  bottle do
    cellar :any
    sha256 "77247a23127acb45413421c1fc1d33f665b6b32726531b88fe693ae25c892676" => :high_sierra
    sha256 "d788bd1d1dbe796827d7a68102f699306c914cecf294789356b0c1e9f1a827bb" => :sierra
    sha256 "0bec0f3866b0f6dbd43eba1230b64af72276331b9356698cf748b62a7ca13cb4" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdill.h>
      #include <stdio.h>
      #include <stdlib.h>

      coroutine void worker(const char *text) {
          while(1) {
              printf("%s\\n", text);
              msleep(now() + random() % 500);
          }
      }

      int main() {
          go(worker("Hello!"));
          go(worker("World!"));
          msleep(now() + 5000);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldill", "-o", "test", "test.c"
    system "./test"
  end
end
