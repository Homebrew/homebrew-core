class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/2.0.0.tar.gz"
  sha256 "67a8fc1c9bef2b3704381bfb3fb3ce99e3952bc4fea2817729a7180fddf4a71e"

  bottle do
    cellar :any
    sha256 "f62f2b57eba5227047b10254946035cc72b909bef698eecb803faad223b96d76" => :mojave
    sha256 "5bc5fcbcb3e6475d59f7a3b95c494f6e776a6e8b5b903217267195dfd8ed761a" => :high_sierra
    sha256 "1aa2aab043cb9358898b7c9f3c33c727e72342b414048620be561cfca8bc839a" => :sierra
    sha256 "33e6599cba76ac835cb2ffc597f8358a8b13c7cd19c7ce9b85a3d3ff60ec4327" => :el_capitan
    sha256 "594c0042c86a0a6aeca3b7286435b3cc9593ffa158f921092df90f0aef3a865e" => :yosemite
  end

  depends_on "cmake" => :build

  # fatal error: 'stdatomic.h' file not found
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <soundio/soundio.h>

      int main() {
        struct SoundIo *soundio = soundio_create();

        if (!soundio) { return 1; }
        if (soundio_connect(soundio)) return 1;

        soundio_flush_events(soundio);
        soundio_destroy(soundio);

        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsoundio", "test.c", "-o", "test"
    system "./test"
  end
end
