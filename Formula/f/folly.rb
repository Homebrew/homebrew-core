class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "a5cdbf0e8b5198a0f0e863e9f9e3c35b30a78b189c2cd2f300d2d3ca67c0aa3f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "04a3cdd75fdbd62c6eb072f3ddac22e3c400c268b63f6863bc320428126e4b76"
    sha256 cellar: :any,                 arm64_sonoma:  "ee3641ef12c6d5485611f9c92d75d8f4245c9488af234aace66d7a3d979a5f12"
    sha256 cellar: :any,                 arm64_ventura: "a9fa5567f81c2b5cf5b3afb6ef84f160dbf5869787ea292f3ac00f8647773163"
    sha256 cellar: :any,                 sonoma:        "8e481dcde0e90516806fc0683c47743a1ff2ebac8f742f8681a6d71e3e09962e"
    sha256 cellar: :any,                 ventura:       "2960d7dfbe6dbdf90925dba6da2a4acc6ffa257f086c740a81428a65d5aca48c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1786f6dfb6245ce284f2c364ccab969cbd7e490434ab3992dac903e5661c113c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7421845887851139553c002cbf6beb800c015e40e45703c2a020b109e33aebbb"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/facebook/folly/issues/2489
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMake/folly-config.cmake.in b/CMake/folly-config.cmake.in
index 0b96f0a10..800a3d90b 100644
--- a/CMake/folly-config.cmake.in
+++ b/CMake/folly-config.cmake.in
@@ -38,7 +38,6 @@ find_dependency(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
diff --git a/CMake/folly-deps.cmake b/CMake/folly-deps.cmake
index 7dafece7d..eaf8c2379 100644
--- a/CMake/folly-deps.cmake
+++ b/CMake/folly-deps.cmake
@@ -41,7 +41,6 @@ find_package(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
