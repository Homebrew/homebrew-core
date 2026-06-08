class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  url "https://openal-soft.org/openal-releases/openal-soft-1.25.2.tar.bz2"
  sha256 "1dbaac44e7579d5bc8847ca8db4b2e8b9fd3961041f35ee20def4958301e1089"
  license "LGPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f880824c9b92cf6e9e9d75cc0119d4a3aa2a7db0da9bae18a0a20e87cb00dd30"
    sha256 cellar: :any,                 arm64_sequoia: "adb88d850324769a3251f90bac3429dbdaa9269bbb0841f6ac7b218a1ffdcf4d"
    sha256 cellar: :any,                 arm64_sonoma:  "e3d8931b07469fda75b098324da091b92235ea8120a3f2d107487e6db42af113"
    sha256 cellar: :any,                 sonoma:        "56c3ef78464993c58c095113234b398b7f9cc42a87debf09eaf53ec992cdde36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a155e053524da0522d71df4896eb2d83594d16ae2a28e68e7240bbf41a0b0eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f81edc9489d8457835d457054ae5e89ac20e33cc49d309106fae701a4609112"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "binutils" => :build # Ubuntu 22.04 ld has relocation errors
  end

  fails_with :clang do
    build 1699
    cause "error: no member named 'join' in namespace 'std::ranges::views'"
  end

  def install
    # Please don't re-enable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = %W[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopenal"
    system "./test"
  end
end
