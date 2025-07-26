class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/4.6.02/kokkos-4.6.02.tar.gz"
  sha256 "baf1ebbe67abe2bbb8bb6aed81b4247d53ae98ab8475e516d9c87e87fa2422ce"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    args = std_cmake_args + [
      "-DKokkos_ENABLE_OPENMP=ON",
      "-DKokkos_ENABLE_TESTS=OFF",
      "-DKokkos_ENABLE_EXAMPLES=OFF",
      "-DKokkos_ENABLE_BENCHMARKS=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--prefix", prefix

    # Remove Homebrew shim references from installed files
    inreplace bin/"kokkos_launch_compiler", Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace lib/"cmake/Kokkos/KokkosConfigCommon.cmake", Superenv.shims_path/ENV.cxx, ENV.cxx
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

    flags = ["-std=c++17", "-I#{include}", "-L#{lib}", "-lkokkoscore"]

    # Platform-specific OpenMP linking flags
    flags += if OS.mac?
      ["-Xpreprocessor", "-fopenmp", "-I#{Formula["libomp"].opt_include}",
       "-L#{Formula["libomp"].opt_lib}", "-lomp"]
    else
      # Linux - use GCC's built-in OpenMP
      ["-fopenmp"]
    end

    system ENV.cxx, "minimal.cpp", *flags, "-o", "test"
    system "./test"
  end
end
