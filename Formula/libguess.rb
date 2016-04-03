class Libguess < Formula
  desc "Character set guessing library"
  homepage "http://atheme.org/projects/libguess.html"
  url "http://rabbit.dereferenced.org/~nenolod/distfiles/libguess-1.2.tar.bz2"
  sha256 "8019a16bdc7ca9d2efbdcc1429d48d033d5053d42e45fccea10abf98074f05f8"

  head do
    url "https://github.com/kaniini/libguess.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      #include <libguess.h>

      int main(int argc, char **argv) {
        const char *buf = "안녕";
        printf("%s", libguess_determine_encoding(buf, strlen(buf), GUESS_REGION_KR));
        return (libguess_validate_utf8(buf, strlen(buf)) == 1) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libguess", "-L#{lib}", "-lguess", "-o", "test"
    assert_match "UTF-8", shell_output("./test")
  end
end
