class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.0.0/kokkos-5.0.0.tar.gz"
  sha256 "c45f3e19c3eb71fc8b7210cb04cac658015fc1839e7cc0571f7406588ff9bcef"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d28b12d4d7526ab7d4913f9e6528549ce289da8251368a94bdd7ad3b76eed51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5550105baedaeecf14ca78f96843bbc6b278d60c7e282374f4bd4901a5aaaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6996c7d11551f169d95b1926b54c78d4e1a0ae8dba0f2f110a3af7c1078e252b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae3e40a3c7bdab67f66de6e40c9714020d2ce09ac8f193f7edf92b1fb725b185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf23bca3e15af3d30b89a8beaee75dbd9e4ca08a1ae18b60118544f75237bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0effa6677e6bea0b7f92a60fea4e73de45572b9e02f7778b797afb83e9e4f4e3"
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
