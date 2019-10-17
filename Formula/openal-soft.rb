class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.19.1.tar.bz2"
  sha256 "5c2f87ff5188b95e0dc4769719a9d89ce435b8322b4478b95dd4b427fe84b2e9"
  head "https://github.com/kcat/openal-soft.git"

  bottle do
    cellar :any
    sha256 "9d3d985b4b1b739da6f8e12cc4365ec0b05f9c272fbeb7d138c696a9d4861ef1" => :catalina
    sha256 "e92caf6e45539adcefec9fc8e9c78e4e2a7a0dc0792442c891ef6473030b51bb" => :mojave
    sha256 "1a16c1d226f08047d499020a07e5ed8731d9f4ba7eadfb286e4357de36783629" => :high_sierra
    sha256 "d136a5196e8c2eb28804027287ca62068d58c2867eaf67ee28576099d94a7b1d" => :sierra
  end

  keg_only :provided_by_macos, "macOS provides OpenAL.framework"

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
