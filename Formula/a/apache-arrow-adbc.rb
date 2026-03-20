class ApacheArrowAdbc < Formula
  desc "Cross-language, Arrow-native database access"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-22/apache-arrow-adbc-22.tar.gz"
  sha256 "48b19d70a734e789da99e3c53ebad57389c914b85fdc9c509188e5f50896b07c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09c3326e64b1da083411eebc53b882f2a44d5b8e05f9653c4d1dd9836de9cdba"
    sha256 cellar: :any,                 arm64_sequoia: "bbdb22e6f017cbea2ffd357d6efeee791699e36f287efc217bbf6ee20c82ba8c"
    sha256 cellar: :any,                 arm64_sonoma:  "c8fe3ceb6858038992a2980b56cc29d1033e823388866733ef3fc039c49f7624"
    sha256 cellar: :any,                 sonoma:        "b77060aad307f0da43f47fecb2afc46547e7c91ad8d97ac18fd7e539b4b3484f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e45987e433d2d9aa581e6ff43241cd13e1907aca8e657d5f2d2064bd5216a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458058601db075f0318d9146f7eb39911ea829ab706c42747a07e0cfd268b59f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "sqlite" # Needs sqlite3_load_extension

  def install
    args = %w[
      -DADBC_BUILD_STATIC=OFF
      -DADBC_BUILD_SHARED=ON
      -DADBC_DRIVER_MANAGER=ON
      -DADBC_DRIVER_POSTGRESQL=ON
      -DADBC_DRIVER_SQLITE=ON
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
