class ProtobufAT29 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v29.5/protobuf-29.5.tar.gz"
  sha256 "a191d2afdd75997ba59f62019425016703daed356a9d92f7425f4741439ae544"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "616d65a04b02074367573c0bea0ffb133b89ad470804841778d4758feec41aa1"
    sha256 cellar: :any, arm64_sequoia: "fef5a90244ab3e532e4f43518617add48a4dc61d4eb99edf9ea47d369ad77ca8"
    sha256 cellar: :any, arm64_sonoma:  "ee897a1b5aff607996794af0dbe8aa40e8ae16504c198080dcba293d3d3ca026"
    sha256 cellar: :any, sonoma:        "c11113e1ac68bad958f74eb8b872d9661b4871d98f68cfb8b14554762b64a71f"
    sha256               arm64_linux:   "50f54d1a9abff5aca57a14de936178fd79dac5e614f6e9f4ce70d534eb9f0797"
    sha256               x86_64_linux:  "220ac17be42d835cb5742b9e890b48414917150d2c30f1f1d23b0c1d24cfca2b"
  end

  keg_only :versioned_formula

  # Support for protoc 29.x (protobuf C++ 5.29.x) will end on 2026-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2026-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  # Backport to expose java-related symbols
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/9dc5aaa1e99f16065e25be4b9aab0a19bfb65ea2.patch?full_index=1"
    sha256 "edc1befbc3d7f7eded6b7516b3b21e1aa339aee70e17c96ab337f22e60e154d7"
  end

  # Backport patch for compatibility with new Abseil.
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/d801cbd86818b587e0ebba2de13614a3ee83d369.patch?full_index=1"
    sha256 "ebab85f5b2c817b4adcd0bc66a7377a0aa4b9ecf667f1893f918c318369d3ef0"
  end

  # Backport of (for compatibility with new Abseil):
  # https://github.com/protocolbuffers/protobuf/commit/0ea5ccd61c69ff5000631781c6c9a3a50241392c.patch?full_index=1
  # Backport to reduce flaky test failures:
  # https://github.com/protocolbuffers/protobuf/commit/7df353d94a84eacdfc0a19ee6db445d95fc57679.patch?full_index=1
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
diff --git i/src/google/protobuf/arena.h w/src/google/protobuf/arena.h
index 545fd51..55b1ec8 100644
--- i/src/google/protobuf/arena.h
+++ w/src/google/protobuf/arena.h
@@ -32,7 +32,6 @@ using type_info = ::type_info;
 #include "absl/base/optimization.h"
 #include "absl/base/prefetch.h"
 #include "absl/log/absl_check.h"
-#include "absl/utility/internal/if_constexpr.h"
 #include "google/protobuf/arena_align.h"
 #include "google/protobuf/arena_allocation_policy.h"
 #include "google/protobuf/port.h"
@@ -214,41 +213,31 @@ class PROTOBUF_EXPORT PROTOBUF_ALIGNAS(8) Arena final {
   // otherwise, returns a heap-allocated object.
   template <typename T, typename... Args>
   PROTOBUF_NDEBUG_INLINE static T* Create(Arena* arena, Args&&... args) {
-    return absl::utility_internal::IfConstexprElse<
-        is_arena_constructable<T>::value>(
-        // Arena-constructable
-        [arena](auto&&... args) {
-          using Type = std::remove_const_t<T>;
-#ifdef __cpp_if_constexpr
-          // DefaultConstruct/CopyConstruct are optimized for messages, which
-          // are both arena constructible and destructor skippable and they
-          // assume much. Don't use these functions unless the invariants
-          // hold.
-          if constexpr (is_destructor_skippable<T>::value) {
-            constexpr auto construct_type = GetConstructType<T, Args&&...>();
-            // We delegate to DefaultConstruct/CopyConstruct where appropriate
-            // because protobuf generated classes have external templates for
-            // these functions for code size reasons. When `if constexpr` is not
-            // available always use the fallback.
-            if constexpr (construct_type == ConstructType::kDefault) {
-              return static_cast<Type*>(DefaultConstruct<Type>(arena));
-            } else if constexpr (construct_type == ConstructType::kCopy) {
-              return static_cast<Type*>(CopyConstruct<Type>(arena, &args...));
-            }
-          }
-#endif
-          return CreateArenaCompatible<Type>(arena,
-                                             std::forward<Args>(args)...);
-        },
-        // Non arena-constructable
-        [arena](auto&&... args) {
-          if (PROTOBUF_PREDICT_FALSE(arena == nullptr)) {
-            return new T(std::forward<Args>(args)...);
-          }
-          return new (arena->AllocateInternal<T>())
-              T(std::forward<Args>(args)...);
-        },
-        std::forward<Args>(args)...);
+    if constexpr (is_arena_constructable<T>::value) {
+      using Type = std::remove_const_t<T>;
+      // DefaultConstruct/CopyConstruct are optimized for messages, which
+      // are both arena constructible and destructor skippable and they
+      // assume much. Don't use these functions unless the invariants
+      // hold.
+      if constexpr (is_destructor_skippable<T>::value) {
+        constexpr auto construct_type = GetConstructType<T, Args&&...>();
+        // We delegate to DefaultConstruct/CopyConstruct where appropriate
+        // because protobuf generated classes have external templates for
+        // these functions for code size reasons. When `if constexpr` is not
+        // available always use the fallback.
+        if constexpr (construct_type == ConstructType::kDefault) {
+          return static_cast<Type*>(DefaultConstruct<Type>(arena));
+        } else if constexpr (construct_type == ConstructType::kCopy) {
+          return static_cast<Type*>(CopyConstruct<Type>(arena, &args...));
+        }
+      }
+      return CreateArenaCompatible<Type>(arena, std::forward<Args>(args)...);
+    } else {
+      if (ABSL_PREDICT_FALSE(arena == nullptr)) {
+        return new T(std::forward<Args>(args)...);
+      }
+      return new (arena->AllocateInternal<T>()) T(std::forward<Args>(args)...);
+    }
   }
 
   // API to delete any objects not on an arena.  This can be used to safely
diff --git a/src/google/protobuf/map_test.inc b/src/google/protobuf/map_test.inc
index df8ce2e411631b1dda93f1a8b05602357126d9d4..a87f9dc6df55ef51d4bfbdc9ccb8611984119f38 100644
--- a/src/google/protobuf/map_test.inc
+++ b/src/google/protobuf/map_test.inc
@@ -1365,9 +1365,9 @@ TEST_F(MapImplTest, SpaceUsed) {
 bool MapOrderingIsRandom(int a, int b) {
   bool saw_a_first = false;
   bool saw_b_first = false;
-  std::vector<Map<int32_t, int32_t>> v(50);
-  for (int i = 0; i < 50; ++i) {
-    Map<int32_t, int32_t>& m = v[i];
+  std::vector<Map<int32_t, int32_t>> v;
+  while (v.size() < 100) {
+    Map<int32_t, int32_t>& m = v.emplace_back();
     m[a] = 0;
     m[b] = 0;
     int32_t first_element = m.begin()->first;
