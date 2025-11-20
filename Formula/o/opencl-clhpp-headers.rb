class OpenclClhppHeaders < Formula
  desc "C++ language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2025.07.22.tar.gz"
  sha256 "c1031afde6e9eb042e6fcfbc17078f4b437a7e8d55482a1ca6e0fa762d262a89"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "241fd874a801633618d6afe60986da9baadaa3edf7ef870a3548b68187282970"
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
