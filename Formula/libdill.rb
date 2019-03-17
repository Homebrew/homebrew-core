class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.14.tar.gz"
  sha256 "ebba0e5b433ec123b74a57d49b89dfa673aa258e03e6a452959e556b4c4529b9"

  bottle do
    cellar :any
    sha256 "4e73d37841cbc4fc61bcca3a079eddeae48ba98c0615672089ad8b19b3de6afe" => :mojave
    sha256 "634f34e3f2a20417a73966e67b7df276f4b357468329a382b92e2a80363b6dc9" => :high_sierra
    sha256 "9011c99d5e543e351fc5b08920048b85ddbc9a4ca2a2f86f4dfb49c51da1c41d" => :sierra
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
