class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.1.tar.bz2"
  sha256 "2d51a6529526ef22484f51567e31a5c346a599767991a3dc9d4dcd9d9cec71dd"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1723d1c797edf96136f98ff5ab239f1df2ead4b741c3fb46ba1f43875f31432f" => :sierra
    sha256 "f7c8d730653ed7d3d3d3c6b959c74e43133b15dfb7a43fca16c706da41a78c94" => :el_capitan
    sha256 "26620c32955ff95382094788d7c91165ff9ee2a10b1b0286d38cc5bec55f5d5b" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides OpenAL.framework"

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
    (testpath/"test.c").write <<-EOS.undent
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
