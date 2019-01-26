class Libmpdec < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.4.2.tar.gz"
  sha256 "83c628b90f009470981cf084c5418329c88b19835d8af3691b930afccb7d79c7"

  patch do
    url "https://gist.githubusercontent.com/lpinca/d967706acabeedb7fb4e8d0be5b66f07/raw/1b9080916e153ac05798a08594cf72c21b4b5a90/dylib-patch.diff"
    sha256 "f53486c1a2a7535fae91f0a19f7d2c04ca0b2ee7e5f4c129e8e95e52e6ae9f2e"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpdecimal.h>
      #include <string.h>

      int main() {
        mpd_context_t ctx;
        mpd_t *a, *b, *result;
        char *rstring;

        mpd_defaultcontext(&ctx);

        a = mpd_new(&ctx);
        b = mpd_new(&ctx);
        result = mpd_new(&ctx);

        mpd_set_string(a, "0.1", &ctx);
        mpd_set_string(b, "0.2", &ctx);
        mpd_add(result, a, b, &ctx);
        rstring = mpd_to_sci(result, 1);

        assert(strcmp(rstring, "0.3") == 0);

        mpd_del(a);
        mpd_del(b);
        mpd_del(result);
        mpd_free(rstring);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lmpdec"
    system "./test"
  end
end
