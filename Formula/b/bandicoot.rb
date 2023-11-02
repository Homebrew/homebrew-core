class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/conradsnicta/bandicoot-code/-/archive/1.11.1/bandicoot-code-1.11.1.tar.bz2"
  sha256 "0cee402c824683886a692117fea2a0221561408b6a9e15b8155a43d92d6b1394"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "66416acf5dee54c86d5f767315699876df97d810d336ee32f757b131088d4c04"
    sha256 cellar: :any,                 arm64_monterey: "ef2c316437025325f2a72ab43bd230dc786e163c2189bf6c57a0d0a058baa6c8"
    sha256 cellar: :any,                 sonoma:         "38916439add816ce4cbd1c75aef4281518408d9eb64cd85952977eadc9cf7f89"
    sha256 cellar: :any,                 ventura:        "4cabe1c952d91d673c47f459a92f268a72e53c8565a0ac0dda90f901922e5d4b"
    sha256 cellar: :any,                 monterey:       "12fe566295676c3e3743e706b6a39565f3bd1fa3ec43db122f2f3a97028f6d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be9866cacd911a2ecf25c1c25deb9c05559791423e524da96b574eda4507f2a"
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
