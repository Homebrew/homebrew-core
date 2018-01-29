class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org"
  url "https://github.com/sustrik/libdill/archive/1.6.tar.gz"
  sha256 "2539d3440971c876b117bc87295b0caabc8c8ec5f544856ca9e74ed12705ea51"

  option "without-sockets", "Compile without socket support"
  option "without-threads", "Compile without threading support"
  option "with-valgrind", "Compile with valgrind compatibility"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "valgrind" => :optional

  def install
    sockets = build.with?("sockets") ? "enable" : "disable"
    threads = build.with?("threads") ? "enable" : "disable"
    valgrind = build.with?("valgrind") ? "enable" : "disable"
    system "./autogen.sh"
    system "./configure", "--#{sockets}-sockets",
                          "--#{threads}-threads",
                          "--#{valgrind}-valgrind",
                          "--disable-debug",
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
    system testpath/"test"
  end
end
