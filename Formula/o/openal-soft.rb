class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.23.1.tar.bz2"
  sha256 "796f4b89134c4e57270b7f0d755f0fa3435b90da437b745160a49bd41c845b21"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b5653fb0187830c2b11ae0d51a56cd06ce7dd0a2222db55ba40dc60a772efe0e"
    sha256 cellar: :any,                 arm64_sonoma:   "8b59e267c5b74eb1589b16ed65d920e8b4cf5761d318190ffa89c2557e6fb981"
    sha256 cellar: :any,                 arm64_ventura:  "43fb6822edf9040a20c291059d8c5058a2eb8e128cca5b5fb17a6cda796ed568"
    sha256 cellar: :any,                 arm64_monterey: "483d541fed84fa7a29cc2669acc996590b78fc7558a62fe99c9c3fd99248ec68"
    sha256 cellar: :any,                 arm64_big_sur:  "9c6778d6789405495ae5cc3f8c2226f9fac82736a1d948f91e7a323184cc342e"
    sha256 cellar: :any,                 sonoma:         "015e2ffa2f00290fe2dc4ddf901365779192c2c57db788679a38053a737ebd92"
    sha256 cellar: :any,                 ventura:        "975412df0025e6e37f31342e1a39d14e5a72a04eb5bb35cdd886d6d8ce55e0cf"
    sha256 cellar: :any,                 monterey:       "7a66d48e90256c5677080dc62c66e289847ec61da6642ad76bfc137ad6157307"
    sha256 cellar: :any,                 big_sur:        "60cbe54e4ca2e7b4f459530d42c0e81090dddfad468b412309b1b38f8b687d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d7bab320cf18eec623f5ec1602d92a4f303b0c82371b62ebc47327768752ed"
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
