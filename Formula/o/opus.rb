class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opus-1.5.1.tar.gz", using: :homebrew_curl
  sha256 "b84610959b8d417b611aa12a22565e0a3732097c6389d19098d844543e340f85"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.xiph.org/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "876d4e2f8095a285be2aebbd7cec82a1478bf0a426325b087f94707a75ec0c8c"
    sha256 cellar: :any,                 arm64_ventura:  "c5cee260266dfb70127eb4908852acab61bd273638dbf485611bc010177cff72"
    sha256 cellar: :any,                 arm64_monterey: "efb631b4f92515ad3f21d4049dd96177759b022b0f280f676ace52f1ae7fc6af"
    sha256 cellar: :any,                 sonoma:         "0d041ccc466b1b7d656b1a41df5b4dbc060f585c1f323c1bcde14bd36bb512db"
    sha256 cellar: :any,                 ventura:        "5c391686ac301493a42cc107afc8aeea00312aa9aed1537e3ac4d436692ca457"
    sha256 cellar: :any,                 monterey:       "f7226679dc4731d5d1372657d50b6f0e7d96c21026940fade4f89bfbaa50d6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0774745abad4878f94b0569121a60a4deea4638f3c40fa4aba338ac95c44c6"
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
    system ENV.cxx, "-I#{include}/opus", testpath/"test.cpp",
           "-L#{lib}", "-lopus", "-o", "test"
    system "./test"
  end
end
