class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.13.tar.gz"
  sha256 "bc68e997f40cda0b4b9be57c0ee27d830fcc020854221e6d43af44017bb4b084"

  bottle do
    cellar :any
    sha256 "95db2e72846bfdd82d699ff3f306a1996b1f5e63b5524a562f5cdffa9f66d12d" => :mojave
    sha256 "08bb496704c214d723b7d9295249d646f612d27f170071aca1e25dc5fee7d6ff" => :high_sierra
    sha256 "83a241fa02747f2231076dfaea8d87af44816db11d6af15f0e10efd4bfe87432" => :sierra
    sha256 "59f60913aa966a30939e189adf0bc969ef82c379fc3131dab70262cca0b3e5ba" => :el_capitan
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
