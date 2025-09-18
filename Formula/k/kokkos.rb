class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/4.7.00/kokkos-4.7.00.tar.gz"
  sha256 "126b774a24dde8c1085c4aede7564c0b7492d6a07d85380f2b387a712cea1ff5"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1fd961cffceba68298022156feea4be131a567e25a729a8fb5f718cb93aa1f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39797d15372aa7af10e5550d93a86dd0c84a88a95e4466bc74555cae81b2a1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296ba09f08e88b0ae13f81d8cccaaa29c14578b27742fb290af5818acf54f0ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e844cafaaf72cafd6d230437d95c8ca41dd0d8fe4cf41c98ad386b275640c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd82ca6dcac67fe4c1aa34ff3fe6e19e89cf6cad4443743ee08a59a541984331"
    sha256 cellar: :any_skip_relocation, ventura:       "a53bac49f0ca38255e8cb07f94e834b8b9d0fbd2b86d867f1729b804f41118d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419701c3eb2ddcbb4266393fe80286ae22183172f6d10e9ba90fa2bb5cfce840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c82880246d0f1fdc8de55176c0e7b19c073dd56b549475d0f42c040491b481"
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
