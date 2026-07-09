class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.07.06.00.tar.gz"
  sha256 "c54768eab330bc27636697a667e3db1b237a92fd3260bd65ea3008927886ebe9"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8eb409024d8fe6d8e51e5f0aef655ee48119631dcaf7839f499e8edfa2ea9339"
    sha256 cellar: :any, arm64_sequoia: "f28e5b049f51db4ef3407e2635c358615da4d585559e8b9ea580fd43f8ddcefd"
    sha256 cellar: :any, arm64_sonoma:  "dded2d396a3abd66256bc8ad71b382dadcc68af3aa023c24ec25362865247cc3"
    sha256 cellar: :any, sonoma:        "029f8d95b92d6c4dc94862d01944af687a80d76dd9ef0a6dcd814f36f02aa2ec"
    sha256 cellar: :any, arm64_linux:   "0039de787530894f5fcb98d685d3d57da2f1d1cb93a8d4a7fa84590441eda62f"
    sha256 cellar: :any, x86_64_linux:  "256833c1f069d1dcb53b0d148cd5650435b84416b1454a1e5d2f567fb5620e88"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix fmt 12.2 compat: https://github.com/facebook/folly/pull/2661
  patch do
    url "https://github.com/facebook/folly/commit/dd2a73e8a3b7a9e044918507d52a780cb181f63d.patch?full_index=1"
    sha256 "3b6138a50d31d785817058df5009343b35d52a8386d494e8e5f62202efcc419e"
  end

  # Workaround for arm64 Linux error "Missing variable is: CMAKE_ASM_CREATE_SHARED_LIBRARY"
  # Ref: https://github.com/facebook/folly/pull/2562#issuecomment-3988207056
  patch :DATA

  def install
    args = %w[
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
    system ENV.cxx, "-std=c++20", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/folly/external/aor/CMakeLists.txt b/folly/external/aor/CMakeLists.txt
index e07e58745..1429f54e9 100644
--- a/folly/external/aor/CMakeLists.txt
+++ b/folly/external/aor/CMakeLists.txt
@@ -20,6 +20,10 @@
 # Linux ELF directives (.size, etc.) that Darwin's assembler doesn't support
 if(IS_AARCH64_ARCH)
 
+if(BUILD_SHARED_LIBS)
+  set(CMAKE_ASM_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_LIBRARY})
+endif()
+
 folly_add_library(
   NAME memcpy_aarch64
   SRCS
