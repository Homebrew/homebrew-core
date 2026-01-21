class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.0.1/kokkos-5.0.1.tar.gz"
  sha256 "cf7d8515ca993229929be9f051aecd8f93cde325adac8a4f82ed6848adace218"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beb363f1e859cf25e8eb6ef7d100f73dabd56199129e19ad9888d2a4a07de233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c648d5efbfbafe190b59f44aeaee07538a4c2365c510d09b65de6b5adba338cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1fc7750d4df7f80db3348605af23e866af8bb6fcd4e6a8f125c89bdd718d5c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d4bb820ef3b96813c79c244e571e94838245761b81d7544373eab3d03e7d704"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da08c965df90bc9f82fb9888e5c77c8d92eca785d5a668bac4109ed8e304a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f1352fbb573ea9082f14645ec191a2550b6d6ea9efa79b5494828f8871d62a"
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
