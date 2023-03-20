class OpenclClhppHeaders < Formula
  desc "C++ language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2023.02.06.tar.gz"
  sha256 "2726106df611fb5cb65503a52df27988d80c0b8844c8f0901c6092ab43701e8c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13485d197d76212d440b096bbe0b2efa3090c22b76580b75f74242ea00bbb0bf"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "opencl-headers"

  def install
    system "cmake", "-DBUILD_TESTING=OFF",
                    "-DBUILD_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-S", ".",
                    "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CL/opencl.hpp>
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-c", "-I#{include}", "-I#{Formula["opencl-headers"].include}"
  end
end
