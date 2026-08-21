class ApacheArrowAdbc < Formula
  desc "Cross-language, Arrow-native database access"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-24/apache-arrow-adbc-24.tar.gz"
  sha256 "2b4b420937f62f7ae56f46dbd6951a5e4ef0da43158080a58cb44cdd09a8b2e0"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  livecheck do
    url "https://archive.apache.org/dist/arrow/"
    regex(%r{href=["']?apache-arrow-adbc[._-]v?(\d+(?:\.\d+)*)/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f6de2cd522f1f1d2524591be801b25bf805138ab6f83d68e5125123f0f16c7f"
    sha256 cellar: :any, arm64_sequoia: "045de67546f16a3e1afae952546c1f9b2e6c945cd19d49ec27d9a03f00f99471"
    sha256 cellar: :any, arm64_sonoma:  "02c30b7ba52015e6d4c8ca7fcd047d1585f7e5e319ed666d47776e948322122c"
    sha256 cellar: :any, sonoma:        "05d07245c24167fb78bdcc71c47e0a7f8a74b5ff866cedfc26857ebb099f5141"
    sha256 cellar: :any, arm64_linux:   "2d895b72f7ac881ab337525863787124e64ab7aa47543b37cc407680516758c2"
    sha256 cellar: :any, x86_64_linux:  "d7dc3df9a38610e5173a3630e88abfb6ddedb540ef4565d2a2dddaa453027b38"
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
