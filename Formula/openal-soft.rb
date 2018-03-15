class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.2.tar.bz2"
  sha256 "9f8ac1e27fba15a59758a13f0c7f6540a0605b6c3a691def9d420570506d7e82"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    cellar :any
    sha256 "e166ede768b1bdef14b5ae85043e05b34ac6c53e57bb6f73b4fc4b0954f8aab4" => :high_sierra
    sha256 "24dd59b5106fb9d6884b20aaf0c79691c7d0eda8e13ba5b943ba5bc49a794787" => :sierra
    sha256 "a7946da113c242708cf9aa80c12cc2beedf555fd6a9aed5e7656a983a80e1df4" => :el_capitan
  end

  keg_only :provided_by_macos, "macOS provides OpenAL.framework"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "portaudio" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "fluid-synth" => :optional

  # clang 4.2's support for alignas is incomplete
  fails_with(:clang) { build 425 }

  def install
    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args
    args << "-DALSOFT_EXAMPLES=OFF"

    args << "-DALSOFT_BACKEND_PORTAUDIO=OFF" if build.without? "portaudio"
    args << "-DALSOFT_BACKEND_PULSEAUDIO=OFF" if build.without? "pulseaudio"
    args << "-DALSOFT_MIDI_FLUIDSYNTH=OFF" if build.without? "fluid-synth"

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
