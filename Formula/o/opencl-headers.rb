class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2024.05.08.tar.gz"
  sha256 "3c3dd236d35f4960028f4f58ce8d963fb63f3d50251d1e9854b76f1caab9a309"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "945fb352c3498fa4f11fbcdfb304f15e6d1d93a2d06067c415d2bd57629f7703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7fefcbb260b67476e911a242932caca6aaefb60782511ed6447cec37ffd6ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b400162ef91a258ad6781be96d563ad64049766a1f26811473cd2ef303a8901"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e34f961e0b1cbd0db32254f10ab12911ba34a8f24fd4ce61a7fd3e27df9482"
    sha256 cellar: :any_skip_relocation, sonoma:         "e972ebd7d809c9d806ca099201940dfd6883894cd68245d6c92f17e72463efad"
    sha256 cellar: :any_skip_relocation, ventura:        "85e3005179d1dda7f17507b1fa9d06a438cebe25ebb751bdaf69eb6db9f131ee"
    sha256 cellar: :any_skip_relocation, monterey:       "27b66127a4cd9a9f0b1f46b0598074ed2603b15714cdc23a9caf21c68bce250c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4739a977ffb947a476ace711a6fb79155d9f2ad81f46f9174310626cbbbf78d"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
