class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2025.06.13.tar.gz"
  sha256 "8bf2fda271c3511ee1cd9780b97446e9fa0cf2b0765cdd54aee60074a4567644"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a254d7da40cc5894307683453ce237ed6a4864f48ea7289e2b2b845336690f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a254d7da40cc5894307683453ce237ed6a4864f48ea7289e2b2b845336690f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a254d7da40cc5894307683453ce237ed6a4864f48ea7289e2b2b845336690f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a254d7da40cc5894307683453ce237ed6a4864f48ea7289e2b2b845336690f1"
    sha256 cellar: :any_skip_relocation, ventura:       "9a254d7da40cc5894307683453ce237ed6a4864f48ea7289e2b2b845336690f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd80e14dfdebbc4b2498c950027ed59233d595829cb882c6c500542befdf092c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd80e14dfdebbc4b2498c950027ed59233d595829cb882c6c500542befdf092c"
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
