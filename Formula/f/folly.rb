class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.09.15.00.tar.gz"
  sha256 "36002c4ba91a89a59972807cd02e08fabdb0d6d6461040bbb2f0a7938c550060"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8fc308aa7a8074a1693ae6f9b97329f321f5fd2c6a400751873487734e056718"
    sha256 cellar: :any,                 arm64_sequoia: "90cf6d81ee3d5f602c28530f83bf229bc24278ee4ba4c72730abd5ea6c783230"
    sha256 cellar: :any,                 arm64_sonoma:  "bf5a4c8efedb6cd4ab3d71a768f2a71cc74230064cf526433525f8f603cb40b6"
    sha256 cellar: :any,                 sonoma:        "58477ce783af5d6867b8134d4e2321e90c2bb66309e2aa8f7596f36b43c34f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1bba8d6c215d28526b49c73b03328283b8755b56e77c906e597b3ef465367ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7887909a5d7f47076d27c85156ed562b97d61326d30beb88c25a069de212330"
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
