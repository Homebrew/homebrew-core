class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  sha256 "8ef69921dbdc06bc5bb90513622637a7b83a71f31f5ba377be9d8fd8f57912c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, big_sur:  "bb1f926fad9495f329bf5c6145621cb03102588514955cb05e715fb9ac840dd6"
    sha256 cellar: :any, catalina: "1564bcd5a3bb302cfeea526eedf0c32659b1d53cbda0e5147255475aeffef5a3"
    sha256 cellar: :any, mojave:   "02f3edcd52369a0b2aa5e209f600e686042c695a075161b94138c62207f04db2"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~EOS
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    EOS
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end
