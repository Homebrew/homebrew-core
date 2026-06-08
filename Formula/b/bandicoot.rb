class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/4.0.1/bandicoot-code-4.0.1.tar.bz2"
  sha256 "ee7218bacdcff1532ae0c38e55bf5e135e9e751a565c09bf6d5f17e46acc2104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5a7a7fc61cf9fb8ad9130529fb4e140bb9fce0f0e5a30b638d43a244aa82d5c"
    sha256 cellar: :any,                 arm64_sequoia: "185eaaaf2194de3b8098fcaa3034dfd56ad8375e6af72c073127af52cddab4d7"
    sha256 cellar: :any,                 arm64_sonoma:  "5d696d76802a87c8d6255aa067373621b401a656d5bae5ca4e7859c6e283494a"
    sha256 cellar: :any,                 sonoma:        "98ac87532004ff3351d34aac0a67bf8fb9d9ea8606a8cdcdbf8c8e608480d335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2010e40ea9381e8961abb070794dbdd4648b14e9c72db6c4a315ecd6598e87e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5bb53ea31c86d49fcfb69246082a7e0c4fb3103bedea8e63f7a9384e148867"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "clblast"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    args = ["-DFIND_CUDA=false"]
    # Enable the detection of OpenBLAS on macOS. Avoid specifying detection for linux
    args += ["-DALLOW_OPENBLAS_MACOS=ON", "-DALLOW_BLAS_LAPACK_MACOS=ON"] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Create a test script that compiles a program
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <bandicoot>

      int main(int argc, char** argv) {
        std::cout << coot::coot_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
