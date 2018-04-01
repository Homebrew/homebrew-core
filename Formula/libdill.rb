class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.7.tar.gz"
  sha256 "b78353308cbbcd442f9c3feab86afeac1bf79eb27186bad9f75efc07c4bfedbf"

  bottle do
    cellar :any
    sha256 "acca38e599b8fcc85e2b25b73ca15b2dfa8dbed7c65b308a7e6e9621165e34d8" => :high_sierra
    sha256 "283cfc9126ebac5a80b36c15c23a506cb5163f458b89bc70eb6b429c3abab982" => :sierra
    sha256 "d13a4bb3c6c2db790a147c0f9880f2aa5c2b4b33c1ee8cbf4c1113a8890b6ee9" => :el_capitan
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
