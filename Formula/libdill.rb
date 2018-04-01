class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.7.tar.gz"
  sha256 "b78353308cbbcd442f9c3feab86afeac1bf79eb27186bad9f75efc07c4bfedbf"

  bottle do
    cellar :any
    sha256 "5a9a878697a380071c895103066f64dec1640866b8a42be3686e86f81ba93425" => :high_sierra
    sha256 "2d77d4d8a79e7d33907753178241927862711feaa049f41e0c84166b150df9e7" => :sierra
    sha256 "363996d19ca44f90e7a088195a21628dbd8e1a7fe78b87d2edbb3f7dfebcdb0c" => :el_capitan
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
