class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  stable do
    url "https://github.com/facebook/folly/archive/refs/tags/v2026.03.16.00.tar.gz"
    sha256 "071f5d830a70beb8c193989def4523708c79dc7ee1fa9342c84eb47a5be0ea85"

    # Backport fixes for macOS build
    patch do
      url "https://github.com/facebook/folly/commit/d397633c2976a73939c69916d9db4fead3fd92c1.patch?full_index=1"
      sha256 "0b74418465827b5de62b1fc7f58cb364f017b56cf528a3524276f07a3259ed82"
    end
    patch do
      url "https://github.com/facebook/folly/commit/f43e0079fe3992231dfa2562ac9ae17b4f5e14c5.patch?full_index=1"
      sha256 "1348748fe5fe9af3fd97c8ec2ab67d3a43592f8073459bdca0e29031773e1791"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73226edcf69301fb3b5c4f4e0b52d8350fda48ff55ca537ee7102a89e3330bfb"
    sha256 cellar: :any,                 arm64_sequoia: "4e9dbe16ff06cd1a5b58d3c5f64f26309b27b06ab6e61179d840fa2135a1a799"
    sha256 cellar: :any,                 arm64_sonoma:  "70693044600e55fc48741abfe6d719cd8b223aedb3a215cbe2b7d060a498a2e0"
    sha256 cellar: :any,                 sonoma:        "0c852571552205f52580fffc34a9de312ec97e7b90f2808623c7d89f8b5eab5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "255c20200701372e16c22ee0d4e866894a84646199bdbcc3063f7dfa24ead2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d67a1d52edd0b2118f786be26c85c0d9181000256789158bb3c1c8fb8664d891"
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
