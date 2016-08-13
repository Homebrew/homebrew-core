class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.15.tar.gz"
  sha256 "d50734d75cd719b00c32274a0a926f0cd737bce42546386340f448da7a321097"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    sha256 "dd533475a90551835a0f448367c489c950d8092598ab46eb3a010cdedf87ebce" => :el_capitan
    sha256 "197899365c9d0887bc4f2a36a52bf5034eae7f202d838e9d557868a581852f5a" => :yosemite
    sha256 "27386bf987c2a8f3c80c2126cce36b9e964fc2986818810f69250d4bc7cddc18" => :mavericks
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
