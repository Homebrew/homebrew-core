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
    sha256 cellar: :any,                 arm64_monterey: "4771bdf241551a85e68ae7f9e05f79aa6878f38c36417b98e252adf006c79e39"
    sha256 cellar: :any,                 arm64_big_sur:  "5b883ee0e5bb0eb0863c8e273cbfb35456ba49c382e90a743edb1801129c291f"
    sha256 cellar: :any,                 monterey:       "6a83559c3e5d89ae9f2f101e19765b380d8f90486a03301110e1cfbfd0da415a"
    sha256 cellar: :any,                 big_sur:        "55b322d5be2347f2757ed76bb1707e4205fcbced26b310be8ce9f506d5068f1c"
    sha256 cellar: :any,                 catalina:       "956434e74d538cde83e7fba8a7a4d006d4f821bf4d7a5fd11525f7cb54e314df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5978c91a941b7fedf2dd5e5f7db30764249fa7d01c02d9025ef9bc5a23f227c3"
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
