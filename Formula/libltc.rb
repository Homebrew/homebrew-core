class Libltc < Formula
  desc "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)"
  homepage "https://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.3.1/libltc-1.3.1.tar.gz"
  sha256 "50e63eb3b767151bc0159a3cc5d426d03a42fd69029bc9b3b7c346555f4b709c"
  license "LGPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "749ea141468995c93c9ce63433317d7453c9d4f7214251e7efc19b254308ce16"
    sha256 cellar: :any,                 arm64_big_sur:  "ee2457189224ff2af56fb6696e81f2b1ecf4cb285b9e7d20f2f70c4fc762b446"
    sha256 cellar: :any,                 monterey:       "f6bf5f1b6366328cca58f935645a40719b629d4fb897ac20581692fdad212d1e"
    sha256 cellar: :any,                 big_sur:        "2c69d93b07e1af11b703f6598bfedd51995f84c691ae5e3cdd88e31b614d67f7"
    sha256 cellar: :any,                 catalina:       "c73e9da760961fc899dcd41c52f4e74cf2e29fb8ea619920c06c9ace25f717ab"
    sha256 cellar: :any,                 mojave:         "aecfd413335e0981c5ac452bc0b81bee57d3a4e5974237f5b6a64aae734369cf"
    sha256 cellar: :any,                 high_sierra:    "30f7ddada1d191c63214d44d9acec4862e71bca2ee67368c8546ec7240f65a9a"
    sha256 cellar: :any,                 sierra:         "1c51db3447916e208601775d43fb248bdc76f3b29b6f309ccc74eddc0a11c9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1e76f2fee2534cfee95a78186c162f5d21a8e5efcdaa36c6aa483cab747e4d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      // stripped-down copy of:
      // https://raw.githubusercontent.com/x42/libltc/87d45b3/tests/example_encode.c
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <ltc.h>

      int main(int argc, char **argv) {
        FILE* file;
        double length = 2;
        double fps = 25;
        double sample_rate = 48000;
        char *filename = "#{testpath}/foobar";
        int vframe_cnt;
        int vframe_last;
        int total = 0;
        ltcsnd_sample_t *buf;
        LTCEncoder *encoder;
        SMPTETimecode st;

        const char timezone[6] = "+0100";
        strcpy(st.timezone, timezone);
        st.years = 8;
        st.months = 12;
        st.days = 31;
        st.hours = 23;
        st.mins = 59;
        st.secs = 59;
        st.frame = 0;

        file = fopen(filename, "wb");
        if (!file) {
          fprintf(stderr, "Error: can not open file '%s' for writing.\\n", filename);
          return 1;
        }

        encoder = ltc_encoder_create(sample_rate, fps,
            fps==25?LTC_TV_625_50:LTC_TV_525_60, LTC_USE_DATE);
        ltc_encoder_set_timecode(encoder, &st);

        vframe_cnt = 0;
        vframe_last = length * fps;

        while (vframe_cnt++ < vframe_last) {
          int byte_cnt;
          for (byte_cnt = 0 ; byte_cnt < 10 ; byte_cnt++) {
            ltc_encoder_encode_byte(encoder, byte_cnt, 1.0);

            int len;
            buf = ltc_encoder_get_bufptr(encoder, &len, 1);

            if (len > 0) {
              fwrite(buf, sizeof(ltcsnd_sample_t), len, file);
              total+=len;
            }
          }

          ltc_encoder_inc_timecode(encoder);
        }
        fclose(file);
        ltc_encoder_free(encoder);

        printf("Done: wrote %d samples to '%s'\\n", total, filename);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lltc", "-lm", "-o", "test"
    system "./test"
    assert (testpath/"foobar").file?
  end
end
