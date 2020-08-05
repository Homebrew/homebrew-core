class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.20.1.tar.bz2"
  sha256 "b6ceb051325732c23f5c8b6d37dbd89534517e6439a87e970882b447c3025d6d"
  head "https://github.com/kcat/openal-soft.git"

  bottle do
    cellar :any
    sha256 "b62337bb563eaaacec777b6861de4b6ba1d33ad8e19418b4b5a0cdfb37473fcf" => :catalina
    sha256 "f6448e18550e62cd283bebe24e98f6253c5c18758aeb7c44f3816f1840082b25" => :mojave
    sha256 "26dbb8819cd991e4a901f3f90f0cc2339c9e4220330329dcf7caa37b14d048d7" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args + %w[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DALSOFT_MIDI_FLUIDSYNTH=OFF
    ]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
