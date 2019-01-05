class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.3.tar.gz"
  sha256 "4f3d69aefdf2dbaf9825408e452a8a414ffc60494c70633560700398820dc550"

  bottle do
    cellar :any
    sha256 "284b7f10549043bd3dcd7e1ba8765ef75f5c87c95bf7550d3e60a94eccdafe03" => :mojave
    sha256 "f7a80387cadbc0d3dcdc5cdd3f6ef6dc34d7d136d3ca7a368186dac54e2f43be" => :high_sierra
    sha256 "dd8c973d58d50be078d47efdf50419fa00a36187ed0907d95dc8799b757e2b4a" => :sierra
  end

  head do
    url "https://git.xiph.org/opus.git"

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
