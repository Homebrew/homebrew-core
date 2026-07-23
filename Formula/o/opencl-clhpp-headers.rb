class OpenclClhppHeaders < Formula
  desc "C++ language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2026.05.29.tar.gz"
  sha256 "fafb4fd202d113992c009d46e6358e70076167e62a5baeb377fe813033a2655e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18397e5be17e6421fb8a654666530d31d2b94916b2f877ecf0f8ba2828f9ef69"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "opencl-headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CL/opencl.hpp>
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-c", "-I#{include}", "-I#{Formula["opencl-headers"].include}"
  end
end
