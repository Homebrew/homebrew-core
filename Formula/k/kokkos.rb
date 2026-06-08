class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.1.1/kokkos-5.1.1.tar.gz"
  sha256 "8bdbee0f0ac383436743ad8a9e3e928705b34b31a25a92dc5179c52a3aa98519"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67df6bee45072b72e93fd0558234bff4e761f8205921c7213460c82167ad1f24"
    sha256 cellar: :any,                 arm64_sequoia: "f95bda78be3db9f757a285a7b83dfa4d562438e9f4d7d388bb0e1fbefa1cd183"
    sha256 cellar: :any,                 arm64_sonoma:  "45a5269e3b68ef17296a4f02d31e31fac57bac302407692cabb69c57609b6278"
    sha256 cellar: :any,                 sonoma:        "4ad47a155b302b6c3740cf88273cb000fdd9da93673b90dd1bcdca8fbb06a9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e991ab7077e883453986fdf5b95539c3626abc77da9d3a3cabae7483ebe1150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7418f122faf85fff6bc17a369cb11f24bbd747fd33570545d42f9eac2f21d68b"
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
      %W[-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include} -L#{Formula["libomp"].opt_lib} -lomp]
    else
      # Linux - use GCC's built-in OpenMP
      %w[-fopenmp]
    end

    system ENV.cxx, "minimal.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end
