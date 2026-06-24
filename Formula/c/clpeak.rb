# Why a git URL instead of a release tarball: clpeak derives its version from
# `git describe` (src/common/cmake/version.cmake).  A GitHub source tarball has
# no .git, so the build would fall back to a stale hardcoded version.  Passing
# `tag:` makes Homebrew fetch that tag, so git-describe reports the real version.
class Clpeak < Formula
  desc "Benchmark to measure peak compute, bandwidth, and latency of GPU/CPU devices"
  homepage "https://github.com/krrishnarraj/clpeak"
  url "https://github.com/krrishnarraj/clpeak.git",
      tag:      "2.0.15",
      revision: "5d7b3da31023054c0d8aa7b354647141d85f47ee"
  license "Apache-2.0"
  head "https://github.com/krrishnarraj/clpeak.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake"          => :build
  depends_on "ninja"          => :build
  depends_on "shaderc"        => :build # provides `glslc` to compile the Vulkan shaders
  depends_on "vulkan-headers" => :build # headers only; the loader below is the runtime lib

  depends_on "vulkan-loader" # libvulkan, dlopen'd at runtime

  on_macos do
    depends_on "molten-vk" # Vulkan-over-Metal ICD (OpenCL/Metal come from the macOS SDK)
  end

  on_linux do
    # CPU-backend codegen needs clang: GCC<=14 serialises the kernels' FMA
    # accumulator chains, ~halving fp32/fp64 (see CMakeLists.txt top comment).
    # macOS already builds with AppleClang; on Linuxbrew the default is GCC, and
    # Homebrew exports CC/CXX which suppresses clpeak's own clang auto-detection,
    # so pull in LLVM and force clang in `install`.
    depends_on "llvm" => :build
  end

  def install
    # CUDA/ROCm/oneAPI need vendor toolkits + drivers Homebrew can't provide, so
    # disable them explicitly (they would auto-disable, but this keeps the build
    # deterministic if a system SDK happens to be present on a Linuxbrew box).
    # Metal/OpenCL (macOS) and OpenCL (Linux) stay on and auto-detect.
    args = %w[
      -DCLPEAK_ENABLE_CUDA=OFF
      -DCLPEAK_ENABLE_ROCM=OFF
      -DCLPEAK_ENABLE_ONEAPI=OFF
    ]

    # Build with clang for the CPU-backend codegen.  macOS already uses
    # AppleClang; on Linux point CMake at the brewed LLVM clang explicitly.
    if OS.linux?
      llvm = formula_opt_bin("llvm")
      args << "-DCMAKE_C_COMPILER=#{llvm}/clang"
      args << "-DCMAKE_CXX_COMPILER=#{llvm}/clang++"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_BUILD_TYPE=Release", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # CI runners have no GPU; clpeak must still run and exit cleanly with no
    # devices.  --version exercises the git-describe version wiring.
    system bin/"clpeak", "--help"
    assert_match version.to_s, shell_output("#{bin}/clpeak --version")
  end
end
