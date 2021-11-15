class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.1.tar.gz"
  sha256 "9f9cd4c041f99b5c49ffb7b59d9f12d95b683d88585608aa56a6307667b2b21f"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "726e8ec0713eb452bb744fe9147771bacc2c3713a128aaee03b6ddcc78011d1a"
    sha256 cellar: :any,                 arm64_big_sur:  "eebbc5c7e71710c848eb60b90f946aefdee1b5269c840c30b8098d6bb758500b"
    sha256 cellar: :any,                 monterey:       "73e9acc9ca851c0d7fb92fdb223bf63595c319d7c5e01049388ce7989777852c"
    sha256 cellar: :any,                 big_sur:        "255b6226cdcfaf0d40167012593e863e73dfed2884c10e7fc3eb4018e81712df"
    sha256 cellar: :any,                 catalina:       "1a8314428019cec85756be0ea10bc4703cd754ef78a4cb560ddcc559af616a72"
    sha256 cellar: :any,                 mojave:         "eebb16e048219e5e3d298db0e7ff8a7bfea60d54c4cf08af76efd81647f1b38b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d64a4dd47dc1b66887c0cecd884f0848a801cb2f684cde0f4664e709574067"
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
