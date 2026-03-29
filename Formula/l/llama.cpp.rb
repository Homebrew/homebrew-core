class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8580",
      revision: "7c203670f8d746382247ed369fea7fbf10df8ae0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16914814796a8750604a26b277dd538adab8cdd4549fcc7bca56ee020e4c87bd"
    sha256 cellar: :any,                 arm64_sequoia: "b4e68fa7ffad77d20bbbf1bbfc18f0147f990d5ff8db88d098a379fd29029376"
    sha256 cellar: :any,                 arm64_sonoma:  "fd48f6b88b57954bb02372b08ae20364a79be2be5f0cdb1efbe06790d126c9db"
    sha256 cellar: :any,                 sonoma:        "176acbb1d9f003974f8c31484ca8eee8134777fffe4f50e6f0f65a7b1d7e0090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283ede07b0672a7257571e8307f59a74525a439389cc3f8f7297c69385d15d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fedb981131338d54692286fde02f64ddf0dbf737bbf99798729d270ffe50251"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml"
  depends_on "openssl@3"

  patch :DATA

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/test-sampling.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(llama REQUIRED)
      add_executable(test-sampling #{pkgshare}/test-sampling.cpp)
      target_link_libraries(test-sampling PRIVATE llama)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test-sampling"

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end

__END__
diff --git a/src/llama-model-loader.cpp b/src/llama-model-loader.cpp
index 2457a7e..853c6b3 100644
--- a/src/llama-model-loader.cpp
+++ b/src/llama-model-loader.cpp
@@ -7,16 +7,60 @@
 
 #include <algorithm>
 #include <array>
+#include <cerrno>
 #include <cinttypes>
 #include <cstdint>
+#include <cstdio>
 #include <cstring>
 #include <future>
+#include <limits.h>
 #include <regex>
 
+#ifdef __has_include
+    #if __has_include(<unistd.h>)
+        #include <unistd.h>
+    #endif
+    #if __has_include(<fcntl.h>)
+        #include <fcntl.h>
+    #endif
+#endif
+
 static const size_t kiB = 1024;
 static const size_t MiB = 1024*kiB;
 static const size_t GiB = 1024*MiB;
 
+namespace {
+std::string llama_path_from_file(FILE * file) {
+    GGML_ASSERT(file != nullptr);
+
+#if defined(__APPLE__)
+    std::array<char, PATH_MAX> path_buf{};
+    if (::fcntl(::fileno(file), F_GETPATH, path_buf.data()) == -1) {
+        throw std::runtime_error(std::string("failed to resolve file path: ") + std::strerror(errno));
+    }
+    return path_buf.data();
+#elif defined(__linux__)
+    std::array<char, PATH_MAX> proc_path{};
+    const int fd = ::fileno(file);
+    const int proc_len = std::snprintf(proc_path.data(), proc_path.size(), "/proc/self/fd/%d", fd);
+    if (proc_len < 0 || static_cast<size_t>(proc_len) >= proc_path.size()) {
+        throw std::runtime_error("failed to resolve /proc file path");
+    }
+
+    std::array<char, PATH_MAX> path_buf{};
+    const ssize_t path_len = ::readlink(proc_path.data(), path_buf.data(), path_buf.size() - 1);
+    if (path_len == -1) {
+        throw std::runtime_error(std::string("failed to resolve file path: ") + std::strerror(errno));
+    }
+
+    path_buf[path_len] = '\0';
+    return path_buf.data();
+#else
+    throw std::runtime_error("loading from FILE * requires gguf file pointer support on this platform");
+#endif
+}
+} // namespace
+
 const char * llama_file_version_name(llama_fver version) {
     switch (version) {
         case GGUF_FILE_VERSION_V1: return "GGUF V1 (support until nov 2023)";
@@ -665,8 +709,9 @@ llama_model_loader::llama_model_loader(
             /*.no_alloc = */ true,
             /*.ctx      = */ &ctx,
         };
+        const auto file_path = llama_path_from_file(file);
 
-        metadata_ptr.reset(gguf_init_from_file_ptr(file, params));
+        metadata_ptr.reset(gguf_init_from_file(file_path.c_str(), params));
         metadata = metadata_ptr.get();
         if (metadata == nullptr) {
             throw std::runtime_error(format("%s: failed to load model from file pointer", __func__));
@@ -675,7 +720,7 @@ llama_model_loader::llama_model_loader(
         get_key(llm_kv(LLM_KV_GENERAL_ARCHITECTURE), arch_name, false);
         llm_kv = LLM_KV(llm_arch_from_string(arch_name));
 
-        files.emplace_back(new llama_file(file));
+        files.emplace_back(new llama_file(file_path.c_str(), "rb", use_direct_io));
         contexts.emplace_back(ctx);
 
         // Save tensors data offset info of the main file.
diff --git a/src/llama-model-saver.cpp b/src/llama-model-saver.cpp
index 26864c1..467e8e0 100644
--- a/src/llama-model-saver.cpp
+++ b/src/llama-model-saver.cpp
@@ -9,9 +9,56 @@
 #include "llama-model.h"
 #include "llama-vocab.h"
 
+#include <array>
+#include <cerrno>
+#include <cstdio>
 #include <cstdint>
+#include <cstring>
+#include <limits.h>
+#include <stdexcept>
 #include <string>
 
+#ifdef __has_include
+    #if __has_include(<unistd.h>)
+        #include <unistd.h>
+    #endif
+    #if __has_include(<fcntl.h>)
+        #include <fcntl.h>
+    #endif
+#endif
+
+namespace {
+std::string llama_path_from_file(FILE * file) {
+    GGML_ASSERT(file != nullptr);
+
+#if defined(__APPLE__)
+    std::array<char, PATH_MAX> path_buf{};
+    if (::fcntl(::fileno(file), F_GETPATH, path_buf.data()) == -1) {
+        throw std::runtime_error(std::string("failed to resolve file path: ") + std::strerror(errno));
+    }
+    return path_buf.data();
+#elif defined(__linux__)
+    std::array<char, PATH_MAX> proc_path{};
+    const int fd = ::fileno(file);
+    const int proc_len = std::snprintf(proc_path.data(), proc_path.size(), "/proc/self/fd/%d", fd);
+    if (proc_len < 0 || static_cast<size_t>(proc_len) >= proc_path.size()) {
+        throw std::runtime_error("failed to resolve /proc file path");
+    }
+
+    std::array<char, PATH_MAX> path_buf{};
+    const ssize_t path_len = ::readlink(proc_path.data(), path_buf.data(), path_buf.size() - 1);
+    if (path_len == -1) {
+        throw std::runtime_error(std::string("failed to resolve file path: ") + std::strerror(errno));
+    }
+
+    path_buf[path_len] = '\0';
+    return path_buf.data();
+#else
+    throw std::runtime_error("saving to FILE * requires gguf file pointer support on this platform");
+#endif
+}
+} // namespace
+
 bool llama_model_saver_supports_arch(llm_arch arch) {
     switch (arch) {
         case LLM_ARCH_QWEN3NEXT:
@@ -410,5 +457,6 @@ void llama_model_saver::save(const std::string & path_model) {
 }
 
 void llama_model_saver::save(FILE * file) {
-    gguf_write_to_file_ptr(gguf_ctx, file, false);
+    const auto file_path = llama_path_from_file(file);
+    gguf_write_to_file(gguf_ctx, file_path.c_str(), false);
 }
