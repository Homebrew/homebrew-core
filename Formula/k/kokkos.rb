class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.1.0/kokkos-5.1.0.tar.gz"
  sha256 "7bdbdfc88033ed7d940c7940ed8919e1f2b78a9656c69276beb76ad45c41ec4e"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebc9bb6533eda8d5dbb415fb4ffb6391b589bc135e66c45ae30443fab0dbc019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d0145c257dead6a87a776dafc2a5f57e17db9cc1cfd682a2a503a00df7ed9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6896c39545540162e747fdc5a7723b259a2c55f0f10b798d4888cb6566ab25ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4e100c02966347900d05d7c0425d752818347bc3e09a63878f7ae853513f9cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bef9e8e1473d5359b086574b2a901278edf022b497463aa58bbec489dae82fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f628676472a178f0eff5e71f4fabfb483d539d80b5384b934ee4d0885feff07"
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
