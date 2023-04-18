class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz", using: :homebrew_curl
  sha256 "65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d"
  license "BSD-3-Clause"

  livecheck do
    url "https://archive.mozilla.org/pub/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "5b67ba43cce16fb32e5a44f7236b9866ff88241ad3fb4676ef541d89eb12c0e9"
    sha256 cellar: :any,                 arm64_monterey: "f7e4d08500365985c7f5adebfb7e48393a8d148cba70ad92f4980360919f5ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "e278b9182301daf80621269defffede5d134765b2c907cb921fff44d00ea9fe7"
    sha256 cellar: :any,                 ventura:        "68afef91a4b3026c9c80bf383fb0ac64e51a31bb5dda9c06b28fa0cf0a150d7d"
    sha256 cellar: :any,                 monterey:       "db0f02da71ae2fc11a841f618ab73eb956ea7a20eaf3ee1a093a61fcd3f2f579"
    sha256 cellar: :any,                 big_sur:        "cffbcfe03bf3d0e6a9b9b301dc0ea71974ab6f49e1ab66dd7895679367ecf156"
    sha256 cellar: :any,                 catalina:       "5cb191f66da0ef2b8d03985c79cb18a59506aaba8a01cc0b1a821c293e88d576"
    sha256 cellar: :any,                 mojave:         "21fa4c22a63bccc5e188dabb9c85af63a57d19582c4f616716bccb063e2befec"
    sha256 cellar: :any,                 high_sierra:    "8b45ac09baae56bdc2c7ee224d5a1ae68efb826a9aec2220e0b27e8ce633b8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07546ab58820e7c13d1f5c28fc746b18262820158a3e30c53152db01a6818466"
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
