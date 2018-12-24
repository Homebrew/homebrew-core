class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.18.2.tar.bz2"
  sha256 "9f8ac1e27fba15a59758a13f0c7f6540a0605b6c3a691def9d420570506d7e82"
  head "https://github.com/kcat/openal-soft.git"

  bottle do
    cellar :any
    sha256 "1c9061ea72ae4514cc8d47a251faf23eb0c174786bcfa7ff46b10605aa7a8cb8" => :mojave
    sha256 "e166ede768b1bdef14b5ae85043e05b34ac6c53e57bb6f73b4fc4b0954f8aab4" => :high_sierra
    sha256 "24dd59b5106fb9d6884b20aaf0c79691c7d0eda8e13ba5b943ba5bc49a794787" => :sierra
    sha256 "a7946da113c242708cf9aa80c12cc2beedf555fd6a9aed5e7656a983a80e1df4" => :el_capitan
  end

  keg_only :provided_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # clang 4.2's support for alignas is incomplete
  fails_with(:clang) { build 425 }

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
