class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "0ae857ecb28af95a420c800b21ed2d0f437503e104f841ab8db249df5f4fbe5c"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0b3d080e04feb48c7b1157ac12a382d4b4fc25988980f7c89faff841da7be04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0b3d080e04feb48c7b1157ac12a382d4b4fc25988980f7c89faff841da7be04"
    sha256 cellar: :any_skip_relocation, monterey:       "a0b3d080e04feb48c7b1157ac12a382d4b4fc25988980f7c89faff841da7be04"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b3d080e04feb48c7b1157ac12a382d4b4fc25988980f7c89faff841da7be04"
    sha256 cellar: :any_skip_relocation, catalina:       "a0b3d080e04feb48c7b1157ac12a382d4b4fc25988980f7c89faff841da7be04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66093f798ab10287d25ce8a8fc62b60d6b1a19f2cf599fc9cebbcb459e3d1d0e"
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
