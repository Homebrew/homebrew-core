class OpenclClhppHeaders < Formula
  desc "C++ language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2024.05.08.tar.gz"
  sha256 "22921fd23ca72a21ac5592861d64e7ea53cd8a705fccd73905911f8489519a0b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce515366ce3d34a5587222e51fea930bb46020017af3fe6432bf77d19aae0b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "925332e79f15cd246f2f26a1dd68b91a9d3678304a0a50e951f777b60c2bcfad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf4798ecf063feeda3b9a3e1cb4a67efadc04e2a724af911f10e2c4cc973083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9011d58d7d6a7942b74d70a4155b9192cf6d576e1712be5d988cea7359da709b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f744bde62602af26ddb78570b7d2b41d1907e22b38b9d3e784e11f578c45793"
    sha256 cellar: :any_skip_relocation, ventura:        "8c925952245a63fd1990e7f32074af66a2a8f758be72adaa0b59d22a4ba7ce68"
    sha256 cellar: :any_skip_relocation, monterey:       "9d5af1e0f89554ba2b6e72cd15a81eb4937dd3625c3ad2a7525157878bccdaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669c7dcb52412558cfe3d8ac276ff1c29af9d1121b54ef20847cfe30f3318bb7"
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
