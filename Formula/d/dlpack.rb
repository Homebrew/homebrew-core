class Dlpack < Formula
  desc "Common in-memory tensor structure"
  homepage "https://dmlc.github.io/dlpack/latest"
  url "https://github.com/dmlc/dlpack/archive/refs/tags/v1.3.tar.gz"
  sha256 "f3d567f885f6c142183afc91a58873b31d0e0b36faa2e45c232b98c74596404f"
  license "Apache-2.0"
  head "https://github.com/dmlc/dlpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30a717cecea8548dd3d1e77b92ebcd12f915717236ba86937170b75a29afd1c7"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => :test
  depends_on "python@3.14" => :test

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
    system "python3.14", "test_pure_numpy.py"
  end
end
