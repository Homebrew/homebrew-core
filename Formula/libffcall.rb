class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.3.tar.gz"
  sha256 "81e7e9862e342053b62004e1788b49e80defaa3186d0352cccf6e6b77c823ef2"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any, big_sur:     "d55d915d1eaa2f0f9fc1d417ab8e7b425bf0bd9b20eec50c1fbf3179c68a0d5a"
    sha256 cellar: :any, catalina:    "02b522baa2d0f38a85e3a2bee8adb79644e8c834c486737b81a62945b9ec73d4"
    sha256 cellar: :any, mojave:      "e38d2a42a2ad191847e423028580245f4b84829e5c781f6d58ce7da9981da280"
    sha256 cellar: :any, high_sierra: "d9f7db3318279d7dac5a162de3a251e96c3810be2e70fe8926d93e63b9849045"
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
