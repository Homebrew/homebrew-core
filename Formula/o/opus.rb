class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opus-1.4.tar.gz", using: :homebrew_curl
  sha256 "c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.xiph.org/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d30af277113178e355bf6ca18ae8ca34acfb0e98849edf26761c758d0f42620d"
    sha256 cellar: :any,                 arm64_ventura:  "6901207819378dec2bdac601e2d290e498939af95209438180f3f93a32dda447"
    sha256 cellar: :any,                 arm64_monterey: "e2ba256cb11597c54056f624e086ae6f92488b33967c87ef59a1e0121f0c195d"
    sha256 cellar: :any,                 arm64_big_sur:  "0439a29659def6c80fc81c19fb655c8f1948b090af9e4e22edb825cf568c0487"
    sha256 cellar: :any,                 sonoma:         "83d594d4a0255a37c5c5c33b8b27e3c2ef9ffedaf28510864b34d63dca7632b8"
    sha256 cellar: :any,                 ventura:        "105509c7708dd9befaa5a5451c41d878725e6f2fd7b24eeedb8e74d5a8ec5425"
    sha256 cellar: :any,                 monterey:       "9af359f7b025b55113e4f24136a2da9bdc5f486a9cd45a382805e8371405a637"
    sha256 cellar: :any,                 big_sur:        "ee33952391561419e2420137371c704af877d0f9ed9f06e1f383070c0051e0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534b2fa7c50d3f46518355f2619824287983cdb95705dd1406cf51ae2b7008c3"
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
