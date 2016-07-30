class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.14.tar.gz"
  sha256 "eb990ac8a5847180ee4e7352ab83a6da69bca4be53435f0e44fcb537632bf375"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    sha256 "b1aa8a0679fbdc70e749f467927f12d58e49e70d085e2f11891f449000e84401" => :el_capitan
    sha256 "be6ebc549150ebfb1fb4bd52806d998e63a0e059c3c1c5cefeca5417f5e98ae9" => :yosemite
    sha256 "cb09ad58657e9f165210ac4da2f790fb8876d6f598902492ce3c0d16e9d17918" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "check", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <libmill.h>

      void worker(int count, const char *text) {
          int i;
          for(i = 0; i != count; ++i) {
              printf("%s\\n", text);
              msleep(10);
          }
      }

      int main() {
          go(worker(4, "a"));
          go(worker(2, "b"));
          go(worker(3, "c"));
          msleep(100);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmill", "-o", "test"
    system "./test"
  end
end
