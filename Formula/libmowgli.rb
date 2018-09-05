class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    sha256 "dfeed1d83782fb561eada6aec0de8b656207174b934fee217f7d98418ecf7b16" => :mojave
    sha256 "1fcb475b2d5fbf9bbd86efcfd324a91eb45f81929d9ede4acedbb92bef720f49" => :high_sierra
    sha256 "d656a2546b58d5549621770dec4a02132e4d2b1d28a879f653129c5db6f8749a" => :sierra
    sha256 "12835d9124733d3308ef989381a22fcc36b19862fccda3433877d96b3d9ff087" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
