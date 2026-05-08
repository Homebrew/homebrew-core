class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/5.1.1/kokkos-5.1.1.tar.gz"
  sha256 "8bdbee0f0ac383436743ad8a9e3e928705b34b31a25a92dc5179c52a3aa98519"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd81e59530910c3e3b4f262f4e97374d07c979799038b739d6505c62419ed36d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb0bc4671c24161a1f0ba4735d8e35305509daf02ba0aaa6e90e903ebc4d7d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb13450f99bdfb220a14392fccc93b453e1bd7743afc459a1074753f2242fece"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f8dcfc5e85bc06b0984fde599f94477fbdf550fa2e1800311504b6cd92de4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ef2037f2aa3a781ce6f05f9946534f9f404dca5dc662e7151741d97e91af2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384ff655ff681fa3c212dd34e13a444469bc6ede5b5bba7ed3d03e4a531469d4"
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
