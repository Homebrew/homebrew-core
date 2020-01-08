class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.20.0.tar.bz2"
  sha256 "c089497922b454baf96d5e4bbc1a114cf75c56b44801edc48b9b82ab5ed1e60e"
  head "https://github.com/kcat/openal-soft.git"

  bottle do
    cellar :any
    sha256 "c4015ea65c1201e6aceae1cab1adb1eaf383d5fd814d5a752e2c0d5370ea8049" => :catalina
    sha256 "cdcc313243d0469df2d0742c70abfbcb7b3473f15c9cacb33e131baa241b6e71" => :mojave
    sha256 "8172415cd85b7341b8316b55465cafd06e29d1edf7d9c91b58ca761520e06d64" => :high_sierra
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
