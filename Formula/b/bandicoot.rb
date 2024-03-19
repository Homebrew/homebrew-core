class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/conradsnicta/bandicoot-code/-/archive/1.12.4/bandicoot-code-1.12.4.tar.bz2"
  sha256 "5783888675f75d1f7df6d843ebad5e56e0295150f7e6761e8cdf3aef08deeb3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ea0998294cc56aa17a1b825aaeb8bc54f994a019deb5119f66429a422d93b41"
    sha256 cellar: :any,                 arm64_ventura:  "5c5a46a3094b5876053550fb2090eb8f333cd8a3e924926d3b397a9339781e1c"
    sha256 cellar: :any,                 arm64_monterey: "1d504e3f9c609aea0dc14014b42bb420c3420535bee638cc24ea37aed5c05741"
    sha256 cellar: :any,                 sonoma:         "d1d046525096beb3587b2b1e33c5e41c85d3c4a228e8876702b224f49a5f627d"
    sha256 cellar: :any,                 ventura:        "cb00e91ee1887a9ebf48a96a0ad732900779e5100f349e5e26840fc39b2edb6f"
    sha256 cellar: :any,                 monterey:       "4ba781650d87fdc454921a330251374630aa7f2817604e871da9aaf112654723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fc76f92bca8eac0733008ce1b092ed32e743d70394425342a3918f750703f4"
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
