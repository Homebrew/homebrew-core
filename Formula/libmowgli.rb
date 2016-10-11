class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.0.tar.gz"
  sha256 "46ef60c642c457a5d0e36bfc8c277e74d2ebf4ab9cbc4e40153781ed4ab0fe7d"
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    sha256 "9c178e1261407660ff4d222dc2a1c864b7d8839d374b1fc56d5b653aef9d55d5" => :sierra
    sha256 "589ebb9198954ec9be1b13bb6f9b4eba1dad687ee41d51719ce195c2700d2612" => :el_capitan
    sha256 "4a5be18af974959de8bed7b09b7b3721967de5f3e29f986a7739fb24fcb563e1" => :yosemite
    sha256 "ecb826e4b3993e1c378d8f3368ff91edcb3dabee0bda61cac57a0097b5c95548" => :mavericks
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
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-lmowgli-2"
    system "./test"
  end
end
