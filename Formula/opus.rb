class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz"
  sha256 "65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d"

  bottle do
    cellar :any
    sha256 "4e444558492eff0e4d82646c868d76b63eb2aeb6e35a26712a3cdf17655b17bd" => :catalina
    sha256 "787bf9b6d56f63cc3d0cf0f7f17affeb85b6496b32bf9a200f57431c886ae4a5" => :mojave
    sha256 "187884409b33deb371002701b6ffb790c1832fecbe6b8e79e437039dae87aff8" => :high_sierra
    sha256 "e547bc31c413575fdf2ae68a8e29d1c3835bac45d8ea629f3a194b397c48e581" => :sierra
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
