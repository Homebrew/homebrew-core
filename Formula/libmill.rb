class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.16.tar.gz"
  sha256 "e78f5d87d214f2357c092d236869a9d69c782c88510db4813f53c8d5725f23c4"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    sha256 "c391e988ecbd227890f32afb7e2c969ff473b43ed28398f8aa4a25168c5c8fed" => :sierra
    sha256 "7d0c594cbb2d1294cdb415b26d6afd85f66f2716b158a6d718e8993a4894ff69" => :el_capitan
    sha256 "68395224fbe9d4ed023268f1950108fe9ffcdfeb932c8ec3e54320b7d5081850" => :yosemite
    sha256 "ef669e48e37ea368df93ef9ae1b25af55c16ae1da4ef42b77626c5d3a1aa12e5" => :mavericks
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
