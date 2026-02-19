class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  stable do
    url "https://openal-soft.org/openal-releases/openal-soft-1.25.1.tar.bz2"
    sha256 "4c2aff6f81975f46ecc5148d092c4948c71dbfb76e4b9ba4bf1fce287f47d4b5"

    # Backport support for GCC <= 12
    patch do
      url "https://github.com/kcat/openal-soft/commit/abd510d0aa7a27afc48af25c24ee6d6b544053cb.patch?full_index=1"
      sha256 "4b172d4e0765978562e16ab9cc8226f45b33521f6e4935ff3cc8ef570e57c268"
    end
    patch do
      url "https://github.com/kcat/openal-soft/commit/b8c3593740630cdb3577fcb381e092898759064a.patch?full_index=1"
      sha256 "77d73ff7cf500a46940e2392e2348ca3357f491628abe06a0f36ad4391630ccb"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83919a2e3ef9f755f0066d2df50e09bfaffdae8d07221f387862a9c3fe594813"
    sha256 cellar: :any,                 arm64_sequoia: "dd619b967568f5ba765557475bfba96385b8f5be2d1062cf9328b0ff25fa8e28"
    sha256 cellar: :any,                 arm64_sonoma:  "bc75ac3adacbec25d53de2b2d6b5e9135db5b95e8a6503a8a01edffe1032fa2f"
    sha256 cellar: :any,                 sonoma:        "2c765d69fefa596eac8e5370092b84a693e6c078d901d69d801c192654cd87ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583b33dc70f6b7fd7631b18a92cd109f789005e4bd91297e92ff5a539e458a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bb84bd9af616c2189791b30b51914d2c60a941159bc7587a77b9934071a07e4"
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
