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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f732c34f549bc105ac74a2c57eea035e8d8a4588956dabdde97c3a8993f0b6f0"
    sha256 cellar: :any, arm64_tahoe:       "a6ec50b9050cf2aebd3403dae993d37499a56f5b3aa7e034088970f4864e6117"
    sha256 cellar: :any, arm64_sequoia:     "1648060f2a8454167d03de328d509551a3629f5c0f240d18d1715baf4695428a"
    sha256 cellar: :any, arm64_linux:       "bb5ad337d620639f44896633d3996647462522845d36d412268c6c2c1a247413"
    sha256 cellar: :any, x86_64_linux:      "bef54577209c931c5ba7293035d84cdfc24e676adf7e41f3393bcf846eff199e"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    # Majority of Linux users do not need runtime dependencies as can use system libraries.
    # Others would still need to manually set up and configure an audio backend so
    # requiring any dependencies provides little to no benefit.
    depends_on "alsa-lib" => :build
    depends_on "dbus" => :build
    depends_on "pipewire" => :build
    depends_on "pulseaudio" => :build
  end

  fails_with :clang do
    build 1699
    cause "error: no member named 'join' in namespace 'std::ranges::views'"
  end

  deny_network_access!

  def install
    # Please don't re-enable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = %W[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args += if OS.mac?
      %w[
        -DALSOFT_BACKEND_PULSEAUDIO=OFF
      ]
    else
      # Make sure support for common audio backends are available
      %w[
        -DALSOFT_REQUIRE_ALSA=ON
        -DALSOFT_REQUIRE_PIPEWIRE=ON
        -DALSOFT_REQUIRE_PULSEAUDIO=ON
      ]
    end

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
