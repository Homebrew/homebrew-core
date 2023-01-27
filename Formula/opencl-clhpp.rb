class OpenclClhpp < Formula
  desc "OpenCL API C++ bindings"
  homepage "https://github.com/KhronosGroup/OpenCL-CLHPP"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "999dec3ebf451f0f1087e5e1b9a5af91434b4d0c496d47e912863ac85ad1e6b2"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "opencl-headers"
  depends_on "opencl-icd-loader"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <CL/opencl.hpp>

      int main() {
        std::cout << "opencl.hpp standalone test PASSED." << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include}", "-I#{Formula["opencl-headers"].opt_include}",
                    "-framework", "OpenCL"
    assert_equal "opencl.hpp standalone test PASSED.\n", shell_output("./test")
  end
end
