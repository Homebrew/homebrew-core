class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.9.tar.gz"
  sha256 "8b6b679a1c0e3071a488905c51c21ea9fda7567f8744c33576074124d306202e"

  bottle do
    cellar :any
    sha256 "7249c2040cd3a5fd4058ad28e1f2dd25e552ab0a23138776edd445b795099df7" => :high_sierra
    sha256 "be553f9e5a9019a013b16d1df66810dd6475cdc4e399e4f91749f3f0f4e6955e" => :sierra
    sha256 "052a3fd8d95b2083364dff50f2589801fe0ab64b9cc5d42ad2a2840d4f319e80" => :el_capitan
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
