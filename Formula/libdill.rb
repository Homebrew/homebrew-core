class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.14.tar.gz"
  sha256 "ebba0e5b433ec123b74a57d49b89dfa673aa258e03e6a452959e556b4c4529b9"

  bottle do
    cellar :any
    sha256 "124f2fd7aa4ba68e528bd2700637511943ae55ec9c2b2c9dcdb3bff1f2e34909" => :catalina
    sha256 "7ebbbe85ab5989b48664688c9fdc833b4bbc7846ea94f3f73c34ef620026b878" => :mojave
    sha256 "062d2f9f6fdeb5588036d3e06752ecfd95b5f4e7b6008b727208fc0a2e7f50a6" => :high_sierra
    sha256 "6f75a82c15eafe6818b0d79e9c55df0654c6665f37841ee21cf7fb90ac578a92" => :sierra
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
