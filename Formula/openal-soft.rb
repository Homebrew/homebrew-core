class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.22.2.tar.bz2"
  sha256 "ae94cc95cda76b7cc6e92e38c2531af82148e76d3d88ce996e2928a1ea7c3d20"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34be8091e5fc5fd6dcf48f426d9a43ae881c6e1396a6d2af071389d0096e9949"
    sha256 cellar: :any,                 arm64_monterey: "133ce78332a497b04b5c8be347e9675679ed67faf99b2b43b74dc9e56c5c2ad4"
    sha256 cellar: :any,                 arm64_big_sur:  "490c40e73b5a3cec76223b7ca92ffd7988a667457bb91e632bdce84d014237d3"
    sha256 cellar: :any,                 ventura:        "ef1c2523054a7e9b1fbb23ad8f88b6650bb809142e45e3e8cb84c681cb936813"
    sha256 cellar: :any,                 monterey:       "24d674a6f074ab4d4ee04e65eadab288b659bf364a7626d321cc70d47dc6f8ef"
    sha256 cellar: :any,                 big_sur:        "065d64b527db40de418fc57e1d8d75b805c8be085d2a72cbacb37df7c7d631f1"
    sha256 cellar: :any,                 catalina:       "71244d998b867c5d79201af0b7a8f1fb7754ba026686ea7e8d05095b3c6fb16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e10ba066e87929ee03a95997aaf59b1e29ae6e2ede24f43185f242ab31a631b3"
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
