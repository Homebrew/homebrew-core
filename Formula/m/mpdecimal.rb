class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.1.tar.gz"
  sha256 "96d33abb4bb0070c7be0fed4246cd38416188325f820468214471938545b1ac8"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9fa6ced040c13747f9b010f406453c14041659dfb496a791b949c163b8a413f5"
    sha256 cellar: :any, arm64_sequoia: "9e2dc44e47e91465c3cefa8969baa6af53a1ec339eda8443b18a30786147203e"
    sha256 cellar: :any, arm64_sonoma:  "594c572777fc4e03ca32d1d2772a4ee69791373fb1eab6b9e673564f131d13e4"
    sha256 cellar: :any, arm64_linux:   "49590f6b1d059b895496e768d9e13004b6fad8e66f1c446dc79a41802c16e482"
    sha256 cellar: :any, x86_64_linux:  "d92d8706831c7dfa2fdd0f1a0d8548137a7ef325ae5c5a7f98fb5090182d6974"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    ENV.append "LDXXFLAGS", "-Wl,-rpath,#{rpath}"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lmpdec"
    system "./test"
  end
end
