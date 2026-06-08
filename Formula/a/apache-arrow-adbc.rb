class ApacheArrowAdbc < Formula
  desc "Cross-language, Arrow-native database access"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-23/apache-arrow-adbc-23.tar.gz"
  sha256 "c74059448355681bf306008e559238ade40af01658d6a8f230b8da34d9a40de9"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd1d27b0bc5f4d9252f9c0973140e939c4763f7f6b3eac9dbe65078a5e774631"
    sha256 cellar: :any,                 arm64_sequoia: "8b856b7b61e7f2f14338606792b637da14fed9b38e8f17ab6227807beb46dd77"
    sha256 cellar: :any,                 arm64_sonoma:  "b3f466098710fdde41f81ddc291aaf8bcdb014ae0a6010120bc1fc0c65ff1a13"
    sha256 cellar: :any,                 sonoma:        "54e3f5a01f8c5864ade077a775e8ebbba15ede5a62a09c552cfbbb5915cfa860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b080062754c2263343ad1a1e8dc295ae248e9841be1e17433e50a729fe4ab95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141171b5c5813e34b61840656375cdab38c53bddf6a761dd4178aeb12a34407a"
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
