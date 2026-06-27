class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.06.22.00.tar.gz"
  sha256 "3bcfd5a4ba0065d24632f38e2286c73173f0b5a5bdfd1a21e278ef8e9ebe8363"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61712993a1aba3af68bb595329f13e14034bba27ca15af161e2833875d4f889a"
    sha256 cellar: :any, arm64_sequoia: "4a969acb9c39524c9b3e720d330d05a4c3e730767a17b11c090f9d0d50e2de8d"
    sha256 cellar: :any, arm64_sonoma:  "de367cdd0517d1c36a4983ccd7ca9baac8c6c9f7dd545dab177fb55746991b91"
    sha256 cellar: :any, sonoma:        "bb3f3efbd9708cb181725638627add08a91d4badb8c078511bdf609f4c15c30a"
    sha256 cellar: :any, arm64_linux:   "d6f040ac8b69abbad4182f70a369312d3f8c6c53d26d2db8c1c8f80f669d67da"
    sha256 cellar: :any, x86_64_linux:  "9c6321e3255c3505c1f3d67ea1139a091f4f6883cdba18f115bca096fd88b8da"
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
    url "https://github.com/facebook/folly/commit/4091b8d53a07512d9f8ab2b42d2dd0fddef34e35.patch?full_index=1"
    sha256 "52a2ed7475ba76e54cd902ae035cbc457af565ff0c2cc70453a58fc01b3bc7e9"
  end

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
