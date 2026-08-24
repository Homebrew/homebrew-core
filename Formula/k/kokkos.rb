class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.2.1/kokkos-5.2.1.tar.gz"
  sha256 "3f754c99aa6130b1dd6520d904db7b2fd44ed618cd91e0dfd921956f23f6812d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5dcb045088638adcc72fee127b7df17c3fd109373b4838ad2c665e53898b10af"
    sha256 cellar: :any, arm64_sequoia: "2da092ed063f1fdb11b9c5a387f3d5454d853c5e2c0f4397b0484a3e2da8bae0"
    sha256 cellar: :any, arm64_sonoma:  "90fde3ab2c665c9996eed846741bcd91300523e1d4dcb3776de614bfd14a3c5c"
    sha256 cellar: :any, sonoma:        "0210b6301a661415c6ad367531c2e59cd09794beda01d5ab1e91c9353312238d"
    sha256 cellar: :any, arm64_linux:   "c31df52d82804f75715089d5f25121526bef3d9ae3fa6beed89254a0f580a11b"
    sha256 cellar: :any, x86_64_linux:  "c0bf9d61a3f347f92dbbc472475358099bd6f8d3abed7fb2485c15a98425fded"
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
