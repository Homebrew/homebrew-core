class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.2.2/kokkos-5.2.2.tar.gz"
  sha256 "d6557aaef39302282a15f9c770433d1fcdf4e961dfd6d9ed726b9d0d0f546b9f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08f9170928aa7913ad2e22f341122e31594f7e258399000ebef60864a1f5182e"
    sha256 cellar: :any, arm64_tahoe:       "1c5fd2edc5be97606c55a6b6f9bf6ddb7a12b6e547567289e06107c482ca7ae4"
    sha256 cellar: :any, arm64_sequoia:     "ae61d31a20db28ee8709eba2199348abbb86e23cb698da993662df317b763519"
    sha256 cellar: :any, arm64_sonoma:      "637d6f6578b1cbe323844507b588a8765c38003c92ba15b30dc89d70944a7bad"
    sha256 cellar: :any, arm64_linux:       "bf1c8179fa0f5f52c37ffdbbaf5832eea684b503f5bba07148cc6063007973b6"
    sha256 cellar: :any, x86_64_linux:      "b2cf3f3590e8ca59343546e78aa3719d9b47b1980958ec1c5a02371e8efe10e6"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DKokkos_ENABLE_OPENMP=ON
      -DKokkos_ENABLE_TESTS=OFF
      -DKokkos_ENABLE_EXAMPLES=OFF
      -DKokkos_ENABLE_BENCHMARKS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove Homebrew shim references from installed files
    inreplace bin/"kokkos_launch_compiler", Superenv.shims_path, ""
    inreplace lib/"cmake/Kokkos/KokkosConfigCommon.cmake", Superenv.shims_path, ""
  end

  test do
    (testpath/"minimal.cpp").write <<~CPP
      #include <Kokkos_Core.hpp>
      int main() {
        Kokkos::initialize();
        Kokkos::finalize();
        return 0;
      }
    CPP

    # Platform-specific OpenMP linking flags
    extra_args = if OS.mac?
      %W[-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")} -L#{formula_opt_lib("libomp")} -lomp]
    else
      # Linux - use GCC's built-in OpenMP
      %w[-fopenmp]
    end

    system ENV.cxx, "minimal.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end
