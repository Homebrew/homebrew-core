class Gnuregex < Formula
  desc "GNU regex library"
  homepage "https://ftp.gnu.org/old-gnu/regex/"
  url "https://ftp.gnu.org/old-gnu/regex/regex-0.12.tar.gz"
  sha256 "f36e2d8d56bf15054a850128fcb2f51807706a92d3bb4b37ceadd731535ce230"

  def install
    system "./configure"
    system "make", "subdirs=test", "all"
    system "mkdir", "-p", "#{lib}"
    system "libtool", "-lSystem", "-dynamic", "-install_name",
      "#{lib}/libgnuregex.dylib", "-o", "#{lib}/libgnuregex.dylib", "regex.o"
    system "mkdir", "-p", "#{include}"
    system "cp", "regex.h", "#{include}/gnuregex.h"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <regex.h>
      int main(void) {
        regex_t start_state;
        if (regcomp(&start_state, "^\w+$", REG_EXTENDED)) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-I#{include}", "-o", "test"
    system "./test"
  end
end
