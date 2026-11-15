class Dlpack < Formula
  desc "Common in-memory tensor structure"
  homepage "https://dmlc.github.io/dlpack/latest"
  url "https://github.com/dmlc/dlpack/archive/refs/tags/v1.4.tar.gz"
  sha256 "5886003d8558ebe94d94b2f72a191f9843164412ee1d06f2e410d042ea2bb88e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/dmlc/dlpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7a4bb23794feb82ebbb1f9707114f0bf02893d5d3fc6378172e6393a42409a58"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => :test
  depends_on "python@3.15" => :test

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"python").install "apps/numpy_dlpack/dlpack"
    pkgshare.install "apps/numpy_dlpack/test_pure_numpy.py"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include "dlpack/dlpack.h"

      int main(void) {
        printf("%d.%d", DLPACK_MAJOR_VERSION, DLPACK_MINOR_VERSION);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")

    cp pkgshare/"test_pure_numpy.py", testpath

    ENV["PYTHONPATH"] = libexec/"python"
    system python3, "test_pure_numpy.py"
  end
end
