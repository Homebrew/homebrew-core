class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2023.12.14.tar.gz"
  sha256 "407d5e109a70ec1b6cd3380ce357c21e3d3651a91caae6d0d8e1719c69a1791d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, ventura:        "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, monterey:       "eec5d5ce283e821e64a8b12f1f48b8ea80237190d100c457afdb6e194b3632b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3cef650c99495f130b2279c12560445f73e8ec66690f37a9fa796e830e7c3b"
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
