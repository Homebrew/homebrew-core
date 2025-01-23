class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.24.2.tar.bz2"
  sha256 "cd4c88c9b7311cb6785db71c0ed64f5430c9d5b3454e0158314b2ef25ace3e61"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fb5473ffd80dd48af85a21b24e0bdbc661e629d355117ad75d45ff143265118"
    sha256 cellar: :any,                 arm64_sonoma:  "68504c50224e5d693fef6d5cfe7a9cc6e119f1709531a803004dd2bb89149e31"
    sha256 cellar: :any,                 arm64_ventura: "2307bb17041adc9c5cf14ecf18360f145aaee99081111fe91cd3f7dbb60e5526"
    sha256 cellar: :any,                 sonoma:        "8f162f348b92ecf256c64d57651c74a8c4934e30f0f830d48f811c9af00dc3ce"
    sha256 cellar: :any,                 ventura:       "0a9282383e4967f0a581a970c4bf0fdfec176e8e3f90346ac135525bade48a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50343b0d90dd555c440a9a9d3dfd2f1897e8d460c5c7059636288613f3e4f303"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    # Please don't re-enable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = %W[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DALSOFT_MIDI_FLUIDSYNTH=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
