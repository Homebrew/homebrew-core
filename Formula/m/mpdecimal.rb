class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.1.tar.gz"
  sha256 "96d33abb4bb0070c7be0fed4246cd38416188325f820468214471938545b1ac8"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "518dd69097ceef4b2f5b51603d930d7f5a334237c52b83f8d9822e58c83de172"
    sha256 cellar: :any,                 arm64_sequoia: "e21da583e42e86d5a2f0aedfaf7820e51b8af3065da599cff179d1a39903f3ab"
    sha256 cellar: :any,                 arm64_sonoma:  "51a9fd907163c4f99be93607db99668cbb3e115ff577f9413e5dd6e5d4070e2c"
    sha256 cellar: :any,                 arm64_ventura: "e764118699fff81e4861a081d5e50546be2631a2fa2f58f4681dee6727648a87"
    sha256 cellar: :any,                 tahoe:         "1f2c31483c9abd01e1ec3af7be8ca14f02a0cdc920313a8b3ab7d3b0b20a6386"
    sha256 cellar: :any,                 sequoia:       "2d5d6956ca6cafdcd541611c99eed16c0f7a3c7c217efb0141ecfed265716564"
    sha256 cellar: :any,                 sonoma:        "bc8fdd21107bda1c93c82f90f4adad05b85d6b7d175df10d0d566a23a7fd5ab5"
    sha256 cellar: :any,                 ventura:       "40b0bb7a71de19ec68449a7f4f6c3816b625a6499e5119f476b3cec3df2d21ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f5f08846de66026cc3d4029e3202498ffb3996d4eca62623da85ade7b6f106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f540928b0baae439b6b7bbbb54aa0b0d8fda3631a2fb46c1d1ccd6bf9c2b5389"
  end

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
