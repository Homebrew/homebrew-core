class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.15.1/bandicoot-code-1.15.1.tar.bz2"
  sha256 "4b4eab071b967360866f57eab0caa8f953b8cda6144bd94be466a6a44cf3008f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de3f1efae202a944edc10f3810c2393c861b571c7dd13470573ab586b92fb108"
    sha256 cellar: :any,                 arm64_sonoma:  "841556b64eb10367d60d3ebd403228c1e5966aff66ce9bedf334d57d150be0cf"
    sha256 cellar: :any,                 arm64_ventura: "7cc00981886492d1649ddc3de0269b3c96e122eae09041e56e318dd86e8f3739"
    sha256 cellar: :any,                 sonoma:        "a3058e28c6640c4502c73b734fe7e3bc942614961c01fc1736737951a74fce58"
    sha256 cellar: :any,                 ventura:       "22ede33afe93487568160554dc13c5e7c68dcdb90e9e8b89c27e868111913b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba91bcb49aa7baec00742255aeb895731dae3677f6606cf4cb82dc22ac1325e6"
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
