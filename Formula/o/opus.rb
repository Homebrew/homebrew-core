class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-1.5.2.tar.gz"
  mirror "https://github.com/xiph/opus/releases/download/v1.5.2/opus-1.5.2.tar.gz"
  sha256 "65c1d2f78b9f2fb20082c38cbe47c951ad5839345876e46941612ee87f9a7ce1"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "89bfef47e7080459c6295beb518b70faf30474929eccab1ea1e05d76fc513285"
    sha256 cellar: :any,                 arm64_sequoia:  "564c0c7f19ac41ed22baabf7c1bf2e172f81bad60ec211d03bda8eeb42ce2f1a"
    sha256 cellar: :any,                 arm64_sonoma:   "017d3d10cf679cad5cee3501a53945903eabff9f7657214944bf9156f85e9872"
    sha256 cellar: :any,                 arm64_ventura:  "d53715a8e666c4d91917f6746c2516aca2f160294ca5542a7db7a53d953c7447"
    sha256 cellar: :any,                 arm64_monterey: "02260aea3cc13374c4366abb75e14034bb374d76873d4fbbd9f26794e1d727cb"
    sha256 cellar: :any,                 sonoma:         "858dbe63f7a6489d18c9ab19114496081881623319bce3b917e686e63550dd84"
    sha256 cellar: :any,                 ventura:        "742d2b0dabd25100776c6a57743fde9e05b02e154612ead68dc25c1ef57fcc3d"
    sha256 cellar: :any,                 monterey:       "becc7d03c9219308c69f7704d33cc7cf0579a2db902e82ef33bf5266f69a54c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "289beb9cfacf46917db19b01dc58f2409265bc7029ddfbf0dc2def345baf8f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d35c066cdcaad6a6b9f840fc2dd70da4ca02000c11b08674fa065b8bf7a9b925"
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
