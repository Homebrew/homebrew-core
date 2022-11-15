class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "0ae857ecb28af95a420c800b21ed2d0f437503e104f841ab8db249df5f4fbe5c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, ventura:        "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, catalina:       "a7c4edafd1bf9f65e7773083fa37a437ca3cc2f653e816588dfb8f52e4c94d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4699d569be5355b3de7b80a016467d697dda6e2359465d1c687d8968364b0b8"
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
