class ApacheArrowAdbc < Formula
  desc "Cross-language, Arrow-native database access"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-25/apache-arrow-adbc-25.tar.gz"
  sha256 "de2910f951eeb3c57d882e621a32d133580cc6b0ad01ac25056f4ac709b8b2c0"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  livecheck do
    url "https://archive.apache.org/dist/arrow/"
    regex(%r{href=["']?apache-arrow-adbc[._-]v?(\d+(?:\.\d+)*)/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "913d51d369ae668e04cb14bc178ace59798107324769c76495e1320b272ee6e1"
    sha256 cellar: :any, arm64_tahoe:       "a7497abc5c44788a6fb95b4152b09d38f58bb387771ec3e27a229aaa829e8c51"
    sha256 cellar: :any, arm64_sequoia:     "361a3dd8ad3ace591f31a16157d754e8bde3635680f184ab0003dc87cf5c6e71"
    sha256 cellar: :any, arm64_linux:       "339cbc94d9a79077c26c94998c9ab36ea9da0a4065fffb742c6d3d03e700268a"
    sha256 cellar: :any, x86_64_linux:      "1df214b730bf0302fab407434c504aecd2164e55293007ff15c38f3d21c1596e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  deny_network_access!

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
