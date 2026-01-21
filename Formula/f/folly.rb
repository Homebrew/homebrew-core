class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.01.12.00.tar.gz"
  sha256 "4b694698c773a3236d6379316f67872db77070d56ea256bec5759964712f9c34"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19d24f150c417129b27859ace4bf1df8d6ad172c023fba94ae6441b8cc36913f"
    sha256 cellar: :any,                 arm64_sequoia: "b6e44fafe17172ff6c6b5c56d418c5398f62e955afe2c1ceee495e85083e892a"
    sha256 cellar: :any,                 arm64_sonoma:  "049bf35605d3c63de1ecc52e9edc54d0bfc86bf8ff8a83a382e316749f2447de"
    sha256 cellar: :any,                 sonoma:        "d7fb1a29690e2c55e12c4eab17e7b3b44a676c75ee30f081f29e0ef0e1fae2de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "986806c063944919a737b183716136353a58bb54f505066184f1e75360b1196a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76db3e95e8d8dab92a27c5b38d165ffcf71826eaab0460316fbc7cd723ec762"
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

  # Workaround to build with glog >= 0.7
  # ref: https://github.com/facebook/folly/issues/2171
  # ref: https://github.com/facebook/folly/pull/2320
  # ref: https://github.com/facebook/folly/pull/2474
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
index 957ae5c56..fe811d7d9 100644
--- a/CMake/folly-config.cmake.in
+++ b/CMake/folly-config.cmake.in
@@ -30,6 +30,7 @@ set(FOLLY_LIBRARIES Folly::folly)
 
 # Find folly's dependencies
 find_dependency(fmt)
+find_dependency(glog CONFIG)
 
 set(Boost_USE_STATIC_LIBS "@FOLLY_BOOST_LINK_STATIC@")
 find_package(Boost 1.69.0 REQUIRED
diff --git a/CMake/folly-deps.cmake b/CMake/folly-deps.cmake
index 2ca5cfec7..a284a91fe 100644
--- a/CMake/folly-deps.cmake
+++ b/CMake/folly-deps.cmake
@@ -62,7 +62,8 @@ if(LIBGFLAGS_FOUND)
   set(FOLLY_LIBGFLAGS_INCLUDE ${LIBGFLAGS_INCLUDE_DIR})
 endif()
 
-find_package(Glog MODULE)
+find_package(GLOG NAMES glog CONFIG REQUIRED)
+set(GLOG_LIBRARY glog::glog)
 set(FOLLY_HAVE_LIBGLOG ${GLOG_FOUND})
 list(APPEND FOLLY_LINK_LIBRARIES ${GLOG_LIBRARY})
 list(APPEND FOLLY_INCLUDE_DIRECTORIES ${GLOG_INCLUDE_DIR})
