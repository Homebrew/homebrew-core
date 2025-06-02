class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2024.10.24.tar.gz"
  sha256 "159f2a550592bae49859fee83d372acd152328fdf95c0dcd8b9409f8fad5db93"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ca1aea759fd7b22344fb9b3103c071b892e2bae7a47717306c5ed857d8793b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ca1aea759fd7b22344fb9b3103c071b892e2bae7a47717306c5ed857d8793b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48ca1aea759fd7b22344fb9b3103c071b892e2bae7a47717306c5ed857d8793b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ca1aea759fd7b22344fb9b3103c071b892e2bae7a47717306c5ed857d8793b"
    sha256 cellar: :any_skip_relocation, ventura:       "48ca1aea759fd7b22344fb9b3103c071b892e2bae7a47717306c5ed857d8793b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb2cfe0d4bcf9b84ada89ca96c58bf6fb9573f84c9bdfcf1103d0a5ea61a7060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cb70827358da453160139e62a4f60bfbb65499b5f03dd8c2468ef63cf3f315"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
