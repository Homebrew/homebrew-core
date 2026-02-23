class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.02.23.00.tar.gz"
  sha256 "b8cd7d15220d07c939acda904b7a96096e91f42300a8dc865f5022236b1b8b94"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e89c848f5ecc2b582cd6f0de58c6408060632a29ee7908eba2a95370888dd4b2"
    sha256 cellar: :any,                 arm64_sequoia: "a3a9644c73a7d11089769aca129156f1622bf2a69fae833f8ce4c4c54d0cb7fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c060c7012cd759ba23000fef82d5ce4ead9dd767df8427f2e58cb2779d126c24"
    sha256 cellar: :any,                 sonoma:        "30a872cf363d30f97c1d7a5fb76b292f3876cafce2e17c4a0eeae4ba49b9f9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7956a6a6fc872211b52e4f9833e92c90fbf9e475ee167997ad3366605c982dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e01ad159525b43279d1ec39d2340d5ddf6e78acb4c6a542f5d7a6bf310d0407"
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

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
