class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/2.0.0.tar.gz"
  sha256 "67a8fc1c9bef2b3704381bfb3fb3ce99e3952bc4fea2817729a7180fddf4a71e"

  bottle do
    cellar :any
    sha256 "e7e22b9890d244052a61b62da42affa11750a3f1437d9a9c652f4ddb28f6253b" => :catalina
    sha256 "628d236080adb8e63089ce94e4e723c5726128558d09d28d0691669b15ac765c" => :mojave
    sha256 "7b24e3aad33f017119899e24c22ab7d94e6b96d87b10a4dc728e615530ee180e" => :high_sierra
    sha256 "e0b25e880fb129834acc0e446499051bd1d0f9efecc4a9c32c82a77c9c54a378" => :sierra
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
