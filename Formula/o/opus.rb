class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-1.6.1.tar.gz"
  mirror "https://github.com/xiph/opus/releases/download/v1.6.1/opus-1.6.1.tar.gz"
  sha256 "6ffcb593207be92584df15b32466ed64bbec99109f007c82205f0194572411a1"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e8146a64fab2683ea447aaa7d0de0b1d717539b4cdabd1fedd4a510e4be0d1e"
    sha256 cellar: :any,                 arm64_sequoia: "85d6f1e885117016478e468f92033f648d9bab05210708fe195cacefe5be8266"
    sha256 cellar: :any,                 arm64_sonoma:  "9b159efdfe3b5a31e5f4db9bac8cf40054ac301c508215f7db13cfc6ca661a66"
    sha256 cellar: :any,                 sonoma:        "0849d017c155c55ea1fb01b6156ff5dc77f2a2d7fec84592a099c32f6db9eef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f9c65c0f98b50f2e74f6fcd48a4f8ae7511d6c2da5d4ae9ed5fbeb4eb69c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "739c259ce69a8af064bb73412700615a4e76405344c186f056710201f6ffda7b"
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
