class Libshine < Formula
  desc "Super fast fixed-point MP3 encoder with JS/wasm"
  homepage "https://github.com/toots/shine"
  url "https://github.com/toots/shine/archive/refs/tags/3.1.1.tar.gz"
  sha256 "565b87867d6f8e6616a236445d194e36f4daa9b4e7af823fcf5010af7610c49e"
  license "LGPL-2.0-only"
  head "https://github.com/toots/shine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "CFLAGS", "-std=gnu17"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <shine/layer3.h>

      int main(void)
      {
        shine_config_t config = {0};

        config.wave.channels = PCM_MONO;
        config.wave.samplerate = 44100;
        config.mpeg.mode = MONO;
        config.mpeg.bitr = 128;

        shine_t s = shine_initialise(&config);
        if (!s) return 1;

        shine_close(s);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lshine", "-o", "test"
    system "./test"
  end
end
