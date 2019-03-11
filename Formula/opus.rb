class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.3.tar.gz"
  sha256 "4f3d69aefdf2dbaf9825408e452a8a414ffc60494c70633560700398820dc550"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17df40ae84cb18886767abb2d2673b9afd5622512381464971e58edf08bb8c82" => :mojave
    sha256 "5dfd8fc0bceb0bf046d65c27e478789c3bc1400979da9e0b2d99596476717494" => :high_sierra
    sha256 "66c4e0ceb827cdec1ea7225377961f68c4910c0f4b31877b63e03dd4c25542a5" => :sierra
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
