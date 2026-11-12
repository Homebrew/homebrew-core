class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.3.0/kokkos-5.3.0.tar.gz"
  sha256 "f1875cacec93d4d4cbd6f391a38994abb67ccffea5ecee2b4be7a8191941ef88"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7d23c2e4fa7b50da61e3713d6bf7ccd3509323bc00785b27be9fb5479816e761"
    sha256 cellar: :any, arm64_tahoe:       "fe05e914c325f7dd62161ba320b1c6bfaa618b1ad81ddb2ee35df1fcb5ee9e7b"
    sha256 cellar: :any, arm64_sequoia:     "29aab18b1b4ebf9eaa7985b9f948bc5384caaf1a07640160a280465d6650989d"
    sha256 cellar: :any, arm64_linux:       "b2f01ca80d7d5e9a4cf7560befaaa14dd2727d37247cede4dd22eaea993da738"
    sha256 cellar: :any, x86_64_linux:      "c4297214467974d7b1111cc8368fb5de25c2e04209cd77b96b68ccae7db89755"
  end

  depends_on "cmake" => :build
  depends_on "mdspan" => :no_linkage

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

  def install
    args = %W[
      -DKokkos_ENABLE_OPENMP=ON
      -DKokkos_ENABLE_TESTS=OFF
      -DKokkos_ENABLE_EXAMPLES=OFF
      -DKokkos_ENABLE_BENCHMARKS=OFF
      -DKokkos_ENABLE_MDSPAN_EXTERNAL=ON
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
