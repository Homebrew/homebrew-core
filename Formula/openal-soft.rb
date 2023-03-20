class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.23.0.tar.bz2"
  sha256 "057dcf96c3cdfcf40159800a93f57740fe79c2956f76247bee10e436b6657183"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe33fe2321dc3a56d93e66a1885fa2b4bbab01d7d05e033dcc6263ab0ac6ddf5"
    sha256 cellar: :any,                 arm64_monterey: "73884d531330330ed69f01b98a9ee2db0040f83760de6030b485fcc4bc0d2f62"
    sha256 cellar: :any,                 arm64_big_sur:  "15f6a0fce29c7f22b0107c17a80c47a70c41a5c944489ee28feb4ae7ec7b0b97"
    sha256 cellar: :any,                 ventura:        "c96fbbe7765c3ba2cb425916b24ac34eb955781d2f843edda9c2b8494469b6c0"
    sha256 cellar: :any,                 monterey:       "8f5104ada051d551e7248d5f47d9b36973725a737f75fb593cf4f38948b93445"
    sha256 cellar: :any,                 big_sur:        "b9fddf543c46a83df8c15744e0ae53430bc3ed51bb98eccf5010e8a647abceab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70642bf18753fe50fb27330f27822a076dfbd322851a280da2d60e2e432d0e3c"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    # Please don't re-enable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = %w[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DALSOFT_MIDI_FLUIDSYNTH=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
