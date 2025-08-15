class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v32.0/protobuf-32.0.tar.gz"
  sha256 "9dfdf08129f025a6c5802613b8ee1395044fecb71d38210ca59ecad283ef68bb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cece723b28c7fa4eb13b5dcf8ba1b1a714136154679a924ae4ff1a920172ca41"
    sha256 cellar: :any,                 arm64_sonoma:  "2329c04175898c7bd8ef3fbd27aa396bbae728e03b969eafbda1bfbb760be17a"
    sha256 cellar: :any,                 arm64_ventura: "f559fb9d03e60407a79304669c19d80b2b2a39b75e7bf4cfc868e462ebf52a08"
    sha256 cellar: :any,                 sonoma:        "8c0913fdeb505bf4634965ca0bcdf60aa8f6d27cd2629d77a354810e5d5bcb10"
    sha256 cellar: :any,                 ventura:       "387e007b7c9201670a4b9b1a414c270f92ff2cbba953d456296207e8b74f053e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a94f22e1d83f44ef5b1ba85e86263aeb5db2fb4825d949038d8a275ff47ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2363740d512d4c5bef5dfa195e0fb693812e2557359dc57303691ff8f858d12"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  # Test fix for AArch64 Linux.
  patch :DATA

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=ON
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end

__END__
diff --git c/src/google/protobuf/port.h w/src/google/protobuf/port.h
index 10667c69b..b04ea1b6a 100644
--- c/src/google/protobuf/port.h
+++ w/src/google/protobuf/port.h
@@ -23,6 +23,10 @@
 #include <type_traits>
 #include <typeinfo>
 
+#if defined(__ARM_FEATURE_CRC32)
+#include <arm_acle.h>
+#endif
+
 #include "absl/base/optimization.h"
 
 
@@ -802,9 +806,7 @@ inline uint32_t Crc32(uint32_t crc, uint64_t v) {
 #elif defined(__ARM_FEATURE_CRC32)
 
 constexpr bool HasCrc32() { return true; }
-inline uint32_t Crc32(uint32_t crc, uint64_t v) {
-  return __builtin_arm_crc32cd(crc, v);
-}
+inline uint32_t Crc32(uint32_t crc, uint64_t v) { return __crc32cd(crc, v); }
 
 #else
 
