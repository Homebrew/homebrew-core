class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.1.tar.gz"
  sha256 "98d6cf3faba0a6f3e919598cbb21e069f4ba77af09ec968f377ac1b5d3f507d2"
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    sha256 "3fbca1fc1204f1cf8c763e1ebd01f612f60bd1f70b8ac0f2b6a6242e29bfad72" => :sierra
    sha256 "03bf7b7d0f8d96b54ecdd3af714fb74a8e9ca7c8cd320189d29b1db4cd3ed2ff" => :el_capitan
    sha256 "cf0d2986d1afd149fb4ffd4f39cf7b2e2e8dec3f52a0961a7185dda96d05c932" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-L#{lib}", "-lmowgli-2"
    system "./test"
  end
end
