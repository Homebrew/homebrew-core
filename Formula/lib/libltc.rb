class Libltc < Formula
  desc "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)"
  homepage "https://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.3.2/libltc-1.3.2.tar.gz"
  sha256 "0a6d42cd6c21e925a27fa560dc45ac80057d275f23342102825909c02d3b1249"
  license "LGPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "317e8d1f146e9c5118dabea794de694186057e4c71688523946fb24859ed4de7"
    sha256 cellar: :any,                 arm64_monterey: "8289e0f5389ee652949981fbde5d3955d78048707c2731619e2d9d046cf1f89a"
    sha256 cellar: :any,                 arm64_big_sur:  "d003af07740326535cc95332c180cc467b29eaab2d227438e1486c8891bd5560"
    sha256 cellar: :any,                 ventura:        "846224f71e3bc2254b94c41e62e8f02bb125d421bc24e9559fd6fca16ee8da44"
    sha256 cellar: :any,                 monterey:       "9a4cdb442f640d04e8886b888bbc5427b448cc9d7a160672a505fda5fa1371c8"
    sha256 cellar: :any,                 big_sur:        "a8a22a13e7faa84038e3833a7ad379d5ca3afe26670476fad9f87afc5312338a"
    sha256 cellar: :any,                 catalina:       "2489b05efb1e77a52635ff5cded3850b9c1abe861b01145bccba7a2f6edaafaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c160950aa4d33232070cb6607deec9ed4fc9b070dd5dcf0c3221404199016c46"
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
