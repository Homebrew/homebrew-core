class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-1.6.tar.gz"
  mirror "https://github.com/xiph/opus/releases/download/v1.6/opus-1.6.tar.gz"
  sha256 "b7637334527201fdfd6dd6a02e67aceffb0e5e60155bbd89175647a80301c92c"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6ba1de564ef18bd741057c1f07f0144f8fbd5ffef09c82d05345e3c5fb78d27"
    sha256 cellar: :any,                 arm64_sequoia: "d136015b02a7a7af2801d0bb3036a9d900794661daeecfb9560f34c81aaf0794"
    sha256 cellar: :any,                 arm64_sonoma:  "85a6708d203ee37557bf6e83697756d5516b683ccca6be1d6a05ec4a0e8d626c"
    sha256 cellar: :any,                 sonoma:        "97dca40f1a99f9d1c1fbae9fb7ba5c0f7e421502d6feb3cbd7367bb7336abbde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e55c43c9e2cb93e5d2b000bb20eec25c0c6770ab429f2f58f4a7f0b62121a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9792b747ebe79b6075773b1d449a39c87a3ef23d66dfa15b65cc83d28ebefe80"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-doc", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-I#{include}/opus", testpath/"test.cpp",
           "-L#{lib}", "-lopus", "-o", "test"
    system "./test"
  end
end
