class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  # cert expired report https://github.com/kcat/openal-soft/issues/1149
  homepage "https://github.com/kcat/openal-soft"
  # TODO: Remove distfiles.gentoo.org URL when openal-soft.org SSL is fixed.
  # https://github.com/kcat/openal-soft/issues/1176
  url "https://distfiles.gentoo.org/distfiles/08/openal-soft-1.24.3.tar.bz2"
  mirror "https://openal-soft.org/openal-releases/openal-soft-1.24.3.tar.bz2"
  sha256 "cb5e6197a1c0da0edcf2a81024953cc8fa8545c3b9474e48c852af709d587892"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11fe9b015e4afb353bf87231aff595f40c4aa260c386145564ed7eacbfd755d5"
    sha256 cellar: :any,                 arm64_sequoia: "dd26fef51c1884b65ea8fcbed3185d29e3ed93df6f61f1551b8c07c956d293d2"
    sha256 cellar: :any,                 arm64_sonoma:  "c669777ed1c01c23d12f3f9d63baa8a17c6bd64f9041d0f3a9f4423e9e1777b7"
    sha256 cellar: :any,                 arm64_ventura: "adda1372155c4d3108305387fdcbb01fbff2d579fdb77e41f941e6ed74bf27f1"
    sha256 cellar: :any,                 sonoma:        "8a47616d6f215a0199e0d986833cf2e3e2bbb1481a5c29db50cbd543a7cbbe2e"
    sha256 cellar: :any,                 ventura:       "608b94ed45a93779809ae82bda26347504a78a0dfc16383472cbff6d22a9251a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f3b41687a7a0f2c45a9d5969279798c77abd097a180749075c7db06739fad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e51027b581006b7ebcbe897a77d471506cf32d85f887546754ee3cb1edb17cc"
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
