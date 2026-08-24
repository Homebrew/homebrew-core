class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6ec2eab86ed3ce661c0d9b834027870651546138b7b4470fa8ef5533498c79aa"
  license "MIT"
  revision 4
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "856317588f1e0866678da73ee50ac191bc6aba472096b4bb021bafc582d1ee58"
    sha256 cellar: :any, arm64_sequoia: "604afaea83fb354c7b487f975275c0fa30760da9a4e3f27cbeba93e70331ffc5"
    sha256 cellar: :any, arm64_sonoma:  "cb36d918641b9fb2e8e26e70eb2676ffc35b3f46801b0639409d1212a90eecdd"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  # support for mlx_distributed_group_free() (#110)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/1e3c24ffebfdfbeecca054c51637fc4381d98aab.patch?full_index=1"
    sha256 "24831d5bc44b72a0fd027572a4e4eaf754ed9805ffed86185bb8dbdfb6284818"
    type :backport
    resolves "https://github.com/ml-explore/mlx-c/pull/110"
  end

  # support for gguf (#111)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/89d3454ac3f46ff68668dd9f7817c6d47650e47c.patch?full_index=1"
    sha256 "411749fd1908fdee783c3b378471603606852ce3a0ee0011ca5b66f47187b9d3"
    type :backport
    resolves "https://github.com/ml-explore/mlx-c/pull/111"
  end

  # support for graph export (#112)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/782d4712862b247a094086419ce130fd82cf3c53.patch?full_index=1"
    sha256 "4469b3ec2836efeadce98a192ae26f423cdbbd182edcd2126f4a6ef36891ce58"
    type :backport
    resolves "https://github.com/ml-explore/mlx-c/pull/112"
  end

  # regenerate bindings for MLX 0.31.2 (#114)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/fba4470b89073180056c9ea46c443051375f7399.patch?full_index=1"
    sha256 "5102eafc68ea94cbe8cabb4acaa9905e17d1c92cb6a1b8c7f0f73dc863c09609"
    type :backport
    resolves "https://github.com/ml-explore/mlx-c/pull/114"
  end

  # Fix compile cache API changes in MLX 0.32.1. Only uses a subset of the PR commit, so inlining.
  # PR ref: https://github.com/ml-explore/mlx-c/pull/127
  patch :DATA

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DMLX_C_BUILD_EXAMPLES=OFF
      -DMLX_C_USE_SYSTEM_MLX=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-o", "test", "-L#{lib}", "-lmlxc"
    assert_match "array([0, 0.5, 1, 1.5, 2, 2.5], dtype=float32)", shell_output("./test")
  end
end

__END__
diff --git a/mlx/c/compile.cpp b/mlx/c/compile.cpp
index bc7b864..c52b2d2 100644
--- a/mlx/c/compile.cpp
+++ b/mlx/c/compile.cpp
@@ -42,7 +42,7 @@ extern "C" int mlx_detail_compile(
 }
 extern "C" int mlx_detail_compile_clear_cache(void) {
   try {
-    mlx::core::detail::compile_clear_cache();
+    mlx::core::detail::compile_clear_cache(mlx::core::detail::compile_cache());
   } catch (std::exception& e) {
     mlx_error(e.what());
     return 1;
@@ -51,7 +51,8 @@ extern "C" int mlx_detail_compile_clear_cache(void) {
 }
 extern "C" int mlx_detail_compile_erase(uintptr_t fun_id) {
   try {
-    mlx::core::detail::compile_erase(fun_id);
+    mlx::core::detail::compile_erase(
+        mlx::core::detail::compile_cache(), fun_id);
   } catch (std::exception& e) {
     mlx_error(e.what());
     return 1;
