class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.21.1.tar.bz2"
  sha256 "c8ad767e9a3230df66756a21cc8ebf218a9d47288f2514014832204e666af5d8"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "92e045739dcb27b75019946bb931011495b64a1cdebef9413401f476d6480cd0"
    sha256 cellar: :any,                 arm64_big_sur:  "7e15f3c0087f0bce3c5bcad1efd612ffb83327b3cd25702ffc474f6513307d73"
    sha256 cellar: :any,                 monterey:       "d11a12360995b8e9b58ff120b85f6483af88f617b2635cdf96f062b2dd5a2cf7"
    sha256 cellar: :any,                 big_sur:        "275cde0ac6442628e8edbba58a7ff291adc797bcb88ed4b76649a11bf17eb09c"
    sha256 cellar: :any,                 catalina:       "242237bdf9b18a852b185da7b479133af60693403cf2503e517461f5bb579012"
    sha256 cellar: :any,                 mojave:         "da2ec851e3d934085169047429e299bf86c0919a742c0bceac21dd716134ea67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47ca76cd11e7d52061408d93f22f8029340daabf5efa89f7a2123bf6f0cef34"
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
