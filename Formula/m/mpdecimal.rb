class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.0.tar.gz"
  sha256 "942445c3245b22730fd41a67a7c5c231d11cb1b9936b9c0f76334fb7d0b4468c"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "0f5f269bed0e6be2de3edfc4b52867e656f993e5bcff40717f26ee94dd0d2211"
    sha256 cellar: :any,                 arm64_sonoma:   "2965eec8a30f462b3bd6a8cc2756c1645e75f4399471594e434e36e886239e2e"
    sha256 cellar: :any,                 arm64_ventura:  "1fd72d5f4b35a3d4735efd7d934154ec8b3666267571f96d64244ad35b3ee814"
    sha256 cellar: :any,                 arm64_monterey: "57311ecd036fae8d74c541ab5a30944a5a5cfea7abaa6b8c936b7376821edafd"
    sha256 cellar: :any,                 sequoia:        "3d6f4fb042ca6910f8926a094363ccfa1ec8ced0816dc75c6c52f066490d2dc0"
    sha256 cellar: :any,                 sonoma:         "377dc5e30dd1292ac1666dd43a447b861ad283024f70a3e914c7e11572ae869e"
    sha256 cellar: :any,                 ventura:        "bb1729bd410275aab1bd276f99fb22678b6ad53de2c9c474fdda854ed0ebaebd"
    sha256 cellar: :any,                 monterey:       "266a3f517227bb9f3806b18313c3b8a33688f9659e5001751e15f1f38538dacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca79318fa094531bd57b3f07d5b8574cd9986bac4c876043336ea4176e8c294f"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    ENV.append "LDXXFLAGS", "-Wl,-rpath,#{rpath}"
    system "./configure", *std_configure_args
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
