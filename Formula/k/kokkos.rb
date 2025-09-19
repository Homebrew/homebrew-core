class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/4.7.01/kokkos-4.7.01.tar.gz"
  sha256 "404cf33e76159e83b8b4ad5d86f6899d442b5da4624820ab457412116cdcd201"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9000991d4e73900384ce718c2ffb3fd54ca9897e61b64cbdc7912ecfbf28e60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7faf47f3685b91d2bacee7333f3bbe4f382adf077743e29368aff6beefac4ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9bb59190dc1969c205ca26717572f0b8b28cd652eeacd94324b816720cb9f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "84f8d30a1d815b45de40a1eab1725e6072935d629a41fdd28a1304c411fa4d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8986f9c376c4555ae7d1bcdd058637eec4f0816a0dca32dda2fd51d24b0bf5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f0ce6bad4a2e2d1fe35d46d3bddf3f3eba4b7ec00998195bc1576d374346d5"
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

    system ENV.cxx, "minimal.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end
