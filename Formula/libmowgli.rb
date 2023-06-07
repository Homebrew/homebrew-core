class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  license "ISC"
  revision 1
  head "https://github.com/atheme/libmowgli-2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "19a8d7aa0f5c72bf5c7e459c1d6924fc7f5ab479f878c8129de5a3693dae3b8d"
    sha256 cellar: :any,                 arm64_monterey: "476e3d8c4864929ada3e6a5af324c768cb18719e9b2200e7ceeb7fe8711d9a2f"
    sha256 cellar: :any,                 arm64_big_sur:  "706a51d84a1e84e3046231012cce4be4eb78288901bd8f07d274161c187a831c"
    sha256 cellar: :any,                 ventura:        "76457d788e5c2f85dbc452a0232bb38ff256f4136d188983ac8b9af87be78019"
    sha256 cellar: :any,                 monterey:       "62bff6552997f1240e9568627847e46c1f55371f2b383d005a8a62975ed2a029"
    sha256 cellar: :any,                 big_sur:        "f64462da9e3debd990315e0c16ecfcffae50fcdddf44538f125ae9dbd4c98fdc"
    sha256 cellar: :any,                 catalina:       "5ade175e55ef972a810e63c5508941679fb65a8c8583d7844676ce68e6c57dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6251f4bbfcc34a629e644b110d247a21e5ca26464ec056924f718a9ca46a5b71"
  end

  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
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
