class ApacheArrowAdbc < Formula
  desc "Cross-language, Arrow-native database access"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-22/apache-arrow-adbc-22.tar.gz"
  sha256 "48b19d70a734e789da99e3c53ebad57389c914b85fdc9c509188e5f50896b07c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a35bdf7912d038c52bbc6c02b9ccc8c0d3daf1745ef2e0be9378d3e47ffd5426"
    sha256 cellar: :any,                 arm64_sequoia: "a3227f6c0ec168103c6032df45723b2407daef34ea582789042d315001951140"
    sha256 cellar: :any,                 arm64_sonoma:  "7432d11b911c1434a8594039263fe6bf84b586de64e393d26dcda7870263f315"
    sha256 cellar: :any,                 sonoma:        "7763bed036f66e8166974ea1c7b0e78bf25dd8a227696ae7b3d5aeaf94ec777b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f9474b593542cd0e86043999c7d5464bada5705452346aa36527062c7bcfe8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86434868438430a0520e751c1f4a4d8040dd45e4bc2fd0185819400fd9b0b9e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %w[
      -DADBC_BUILD_STATIC=OFF
      -DADBC_BUILD_SHARED=ON
      -DADBC_DRIVER_MANAGER=ON
      -DADBC_DRIVER_POSTGRESQL=OFF
      -DADBC_DRIVER_SQLITE=OFF
    ]
    system "cmake", "-S", "c", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "arrow-adbc/adbc.h"
      int main(void) {
        struct AdbcError error;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-ladbc_driver_manager", "-o", "test"
    system "./test"
  end
end
