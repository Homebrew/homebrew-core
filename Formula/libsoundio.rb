class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/1.1.0.tar.gz"
  sha256 "ba0b21397cb3e29dc8f51ed213ae27625f05398c01aefcfbaa860fab42a84281"

  bottle do
    cellar :any
    sha256 "2834f97ed4a894557fcf3af44f96e733b0987744b991d721c54a5a1879141203" => :el_capitan
    sha256 "b0e334a48e59b046b2fe798dc020424c4ddf82928303de72330c142f2128206e" => :yosemite
    sha256 "bc45824227f9e1c37a26064bf2a146917fa2ad19f82051240865e53028846f2d" => :mavericks
  end

  # fatal error: 'stdatomic.h' file not found
  depends_on :macos => :yosemite

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
