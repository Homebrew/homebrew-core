class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.1.tar.gz"
  sha256 "9f9cd4c041f99b5c49ffb7b59d9f12d95b683d88585608aa56a6307667b2b21f"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "720cac61e7e5d61abb0dd1ba0df369ef7a7b1cf188db7e8a1d22a1e62fc84613" => :big_sur
    sha256 "e0703b703eacc78c9c472e9d4266831ba66a0764310a846e2e8a958a85aa3a28" => :arm64_big_sur
    sha256 "f43f2a183184abe0bf78291472ac115897fb7defda7394f61367659d95c84c5c" => :catalina
    sha256 "9619a02392403884e72cd78113eade5bc7687270a762dabf063231f574966221" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
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
