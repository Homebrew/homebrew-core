class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz"
  sha256 "65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5cb191f66da0ef2b8d03985c79cb18a59506aaba8a01cc0b1a821c293e88d576" => :catalina
    sha256 "21fa4c22a63bccc5e188dabb9c85af63a57d19582c4f616716bccb063e2befec" => :mojave
    sha256 "8b45ac09baae56bdc2c7ee224d5a1ae68efb826a9aec2220e0b27e8ce633b8aa" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-doc", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opus.h>

      int main(int argc, char **argv)
      {
        int err = 0;
        opus_int32 rate = 48000;
        int channels = 2;
        int app = OPUS_APPLICATION_AUDIO;
        OpusEncoder *enc;
        int ret;

        enc = opus_encoder_create(rate, channels, app, &err);
        if (!(err < 0))
        {
          err = opus_encoder_ctl(enc, OPUS_SET_BITRATE(OPUS_AUTO));
          if (!(err < 0))
          {
             opus_encoder_destroy(enc);
             return 0;
          }
        }
        return err;
      }
    EOS
    system ENV.cxx, "-I#{include}/opus", "-L#{lib}", "-lopus",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
