class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.5.tar.gz"
  sha256 "896c82f47597ca1643f776c0141c4e352582d8739d1628caa2e406a1070c92f4"

  bottle do
    cellar :any
    sha256 "b573af4d120876e43cb3d9e822487658bca0bbcbaec2b4b7061e8e4f7b74068e" => :high_sierra
    sha256 "c289a65ded1c77bfa31f624dc6a06de059a8fcda4fc7b2bca9401794bdbf0fa8" => :sierra
    sha256 "3f441463cc4aa3699f4f06df389b21703607894678e46b2f79ef235e50147530" => :el_capitan
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
