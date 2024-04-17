class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.13.0/bandicoot-code-1.13.0.tar.bz2"
  sha256 "f3160f15ddc5aad30696c378a6b5aaa1581cdb4275197014d21a9b8da8f054b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9df22550cc204fdbf10edc50c4b9126937b0d590525ffe5f50f48b148e337d7a"
    sha256 cellar: :any,                 arm64_ventura:  "6ca97904b4e4440164de54ab00dd3476653886b820e3f7036d2ee5eae1f37c8c"
    sha256 cellar: :any,                 arm64_monterey: "1b4c29edb0c2a788994f659ab8cc6447eef51dd0f69bf6846a9248854a790fbf"
    sha256 cellar: :any,                 sonoma:         "bcba0b162d9ac3c64c5957d0c96926e89e017a6457c379a076c65ea5e5d58193"
    sha256 cellar: :any,                 ventura:        "570428ed98291a63018630a9274088a40e1d2d871ba7e932979db8c8a842172b"
    sha256 cellar: :any,                 monterey:       "a5f9d76ddf4a657334e06ea9fd256aef4abe755709f2a4486314a9a8f26ab95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccd49fef0687f098e85fa18457b1351bf3c6954485036b38ce505faf679e455e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "clblas"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    if OS.mac?
      # Enable the detection of OpenBLAS on macOS
      system "cmake", "-S", ".", "-B", "build",
                      "-DALLOW_OPENBLAS_MACOS=ON",
                      "-DALLOW_BLAS_LAPACK_MACOS=ON",
                      *std_cmake_args
    else
      # Avoid specifying detection for linux
      system "cmake", "-S", ".", "-B", "build",
                      *std_cmake_args
    end
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Create a test script that compiles a program
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <bandicoot>

      int main(int argc, char** argv) {
        std::cout << coot::coot_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
