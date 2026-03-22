class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.0.2/kokkos-5.0.2.tar.gz"
  sha256 "188817bb452ca805ee8701f1c5adbbb4fb83dc8d1c50624566a18a719ba0fa5e"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3df9280f1d6263c84962cdf9ae4f82f404c71d2881477adc1dcb894b84ebd2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b538877780df9026ae5cf8b679b8cc1abba90fca1bcbdcddfd5ec29045e7c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0acc835618515c9d62098f1e672d08bfe5598477d46c1b7f46ecd45c5303fe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9aa45a9c304a9969aa2f64d1a6e7fab71829188d732d3d0b0f8c5cc59520b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b6ae931661a41fb12af97d3283d501b6c8c5e0497fcba76a01e83015fd4195b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1239687728a7746ca3d8319acbc931a9ae203a8616d7ed5e18289982b17a5f"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -DKokkos_ENABLE_OPENMP=ON
      -DKokkos_ENABLE_TESTS=OFF
      -DKokkos_ENABLE_EXAMPLES=OFF
      -DKokkos_ENABLE_BENCHMARKS=OFF
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
      %W[-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include} -L#{Formula["libomp"].opt_lib} -lomp]
    else
      # Linux - use GCC's built-in OpenMP
      %w[-fopenmp]
    end

    system ENV.cxx, "minimal.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end
