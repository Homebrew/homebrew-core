class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.3.tar.gz"
  sha256 "f83cba87b1b0d1a8ad0f6345c448c14dee685ee733f3c3ee93f2321acc1bd083"

  bottle do
    cellar :any
    sha256 "738d1ddc18531ffc212457a3c9d0b101030f6392e6d23de4cd7dc16d2f84d0b6" => :high_sierra
    sha256 "f813be0b6511dde61fcb3507d462187aca3fa966dd23dd2a69181abef0f86efc" => :sierra
    sha256 "bf2731c037553ee645a2bdbb0ce98c6e6d802a937e826a7cb7210dacf6117025" => :el_capitan
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
