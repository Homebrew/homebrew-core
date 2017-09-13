class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.2.tar.gz"
  sha256 "0f80125b0b6996d0b5f6258f3dad47faf0165d51c7b4f3a53de4fa4b30809412"
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    sha256 "2629985b967c9be4bbc0db47c21e33dcbc0058b370c4fbdb081d12bf370c2e10" => :sierra
    sha256 "bf9b61a75b2f0a92d811e87a93b07fb1daedd2d096c6576d1993db2b4ec5b685" => :el_capitan
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
