class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.21.0.tar.bz2"
  sha256 "2916b4fc24e23b0271ce0b3468832ad8b6d8441b1830215b28cc4fee6cc89297"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git"

  bottle do
    cellar :any
    sha256 "4bc86ddf78328c9b229e9200b0ff0f35f2c968931558d0471f9d8ef276c9feb2" => :big_sur
    sha256 "8dcfcdbffc46e1c9dd32909dd07f5653c116f56eedbc4b911498d01533138688" => :arm64_big_sur
    sha256 "2f288bddf5b23b868e7ee2773877eeeab70dce4bc3ba7e95fd106753be7e361d" => :catalina
    sha256 "a6fac3b7778cba045106631a61b7f9cf58c189cc27ca210983b3f7c73c48301e" => :mojave
    sha256 "c1f4cf0e42e75b583ff7a78dad6850b6ed8874bb6aeb7734b8116366a5b6697e" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    # Please don't re-enable example building. See:
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
