class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.40.18",
      revision: "924cc286cc592f49c481fa84e15fa60dbc75989e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "811fea96668959630292bbd123030de5b5636e4a0f51992c857420bafc73dd70"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e364fdfeedd2b02b00615788abf9c36c53f88c4b6e6eac72a17a5d1ec369c26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "230e204e7ac2f850733efa1def6a4354c0f138ebfaa4dc6aab07568ec6949973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a09ff62d553e85771014c208a50882fbfbfece8c4a9f88efa651a61fdcbbac59"
    sha256 cellar: :any,                 arm64_linux:       "f9059d016066e0c7b909922495fb8adbbd71a3082e84a7baab0f2467c3a4abe6"
    sha256 cellar: :any,                 x86_64_linux:      "6a1d56214165ff160771b58304b85e0a39fdc810433f18e0d00a0ee9f4112d35"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Build with the mlx-c 0.8.0 bindings for tagged MLX 0.32.4. Upstream targets a later MLX commit:
      # https://github.com/ollama/ollama/commit/66ab8482e08035a3238dff04a5739c4371c61bfe
      # `mlx_fast_scaled_dot_product_attention` has no `window_size` in mlx-c 0.8.0, so apply the window as a mask:
      # https://github.com/ollama/ollama/blob/v0.40.12/mlx/compat/mlx-c/0001-mlx-c-sdpa-window-size.patch
      # mlx-c 0.8.0 also lacks `mlx_cuda_get_arch_list`, only needed for CUDA builds:
      # https://github.com/ollama/ollama/blob/v0.40.15/mlx/compat/mlx-c/0002-cuda-get-arch-list.patch
      patch :DATA
    end
  end

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b12651",
        revision: "f5e6915c28f10330885fcb9243a93ae98d3115ab"

    livecheck do
      url "https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/LLAMA_CPP_VERSION"
      regex(/^v?b(\d+)$/i)
    end

    # fix: don't build AMX by default with Apple clang
    patch do
      url "https://github.com/ggml-org/llama.cpp/commit/1f92170dc9d4620b5aadb9bacba502c726e5b587.patch?full_index=1"
      sha256 "1e51afe4b8cfed5653289270064370d926258b5bbd662a93eac240d7a37f2735"
      type :unofficial
    end
  end

  # Check llama-server binary; it needs a model as upstream builds it without router mode support
  resource "homebrew-test-model", :test do
    url "https://huggingface.co/ggml-org/models/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf"
    sha256 "270cba1bd5109f42d03350f60406024560464db173c0e387d91f0426d3bd256d"
  end

  # downloads go modules in install and runs a server in test
  deny_network_access! :postinstall

  def install
    # Build llama-server
    llama_source_dir = buildpath/"llama.cpp"
    llama_source_dir.install resource("llama.cpp")

    preset = if OS.mac? && Hardware::CPU.arm?
      "darwin"
    else
      "cpu"
    end

    args = %W[
      --preset #{preset}
      -DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP=#{llama_source_dir}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{loader_path}
    ]

    system "cmake", "-S", "llama/server", "-B", "llama-server", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "llama-server"
    system "cmake", "--install", "llama-server", "--component", "llama-server"

    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    mlx_args = []

    # Flags for MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      mlx_rpath = rpath(target: formula_opt_lib("mlx-c"))
      ldflags << "-extldflags '-Wl,-rpath,#{mlx_rpath}'"
      mlx_args << "-tags=mlx"

      # Generate wrappers from our mlx-c; the vendored headers are newer and declare symbols it lacks
      mlx_headers = buildpath/"mlx/include/mlx"
      rm_r(mlx_headers/"c")
      mlx_headers.install_symlink formula_opt_include("mlx-c")/"mlx/c"
      system "go", "generate", *mlx_args, "./mlx"
    end

    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"

    # The mlx runner dlopens MLX libraries from `<exe_dir>/lib/ollama/mlx_*/`.
    # Using `opt` keeps the link stable across mlx-c version bumps.
    if OS.mac? && Hardware::CPU.arm?
      (libexec/"lib/ollama/mlx_metal_v3").mkpath
      ln_sf formula_opt_lib("mlx-c")/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
    end
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  def caveats
    on_linux do
      <<~EOS
        This formula only includes support for the CPU backend.
        You can install Ollama with GPU backends from Homebrew Cask:
          brew install --cask ollama-binary
      EOS
    end
  end

  test do
    # Avoid compiling Metal shaders during backend discovery and the server test.
    ENV["GGML_METAL_DEVICES"] = "0" if OS.mac?

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    # Test MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1")
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output
    end

    testpath.install resource("homebrew-test-model")

    require "pty"

    llama_port = free_port
    output = +""
    r, _w, pid = PTY.spawn(libexec/"lib/ollama/llama-server", "-m", "stories260K.gguf", "--port", llama_port.to_s)
    begin
      timeout = Time.now + 20
      until output.include?("listening on")
        raise "timed out waiting for llama-server to start\n#{output}" if Time.now > timeout

        begin
          output << r.read_nonblock(1024)
        rescue IO::WaitReadable
          sleep 0.1
        rescue EOFError
          break
        end
      end

      assert_match "listening on http://127.0.0.1:#{llama_port}", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/mlx/cuda.go b/mlx/cuda.go
--- a/mlx/cuda.go
+++ b/mlx/cuda.go
@@ -117,21 +117,7 @@
 }
 
 func cudaCompilationTargets() ([]string, error) {
-	targets := mlxCheck(C.mlx_vector_string_new())
-	defer freeVectorString(targets)
-	if err := mlxError(C.mlx_cuda_get_arch_list(&targets)); err != nil {
-		return nil, err
-	}
-
-	result := make([]string, int(mlxCheck(C.mlx_vector_string_size(targets))))
-	for i := range result {
-		var value *C.char
-		if err := mlxError(C.mlx_vector_string_get(&value, targets, C.size_t(i))); err != nil {
-			return nil, err
-		}
-		result[i] = C.GoString(value)
-	}
-	return result, nil
+	return nil, fmt.Errorf("mlx_cuda_get_arch_list is not available in this mlx-c")
 }
 
 func deviceInfoString(info C.mlx_device_info, key string) (string, error) {
diff --git a/mlx/fast.go b/mlx/fast.go
index f9927ca..20012fa 100644
--- a/mlx/fast.go
+++ b/mlx/fast.go
@@ -21,6 +21,13 @@ func FastScaledDotProductAttention(q, k, v *Array, scale float32, windowSize int
 // windowSize restricts each query to the most recent windowSize keys
 // (sliding window attention); pass FastSDPANoWindow for full context.
 func FastScaledDotProductAttentionWithSinks(q, k, v *Array, scale float32, windowSize int, mode string, mask, sinks *Array) *Array {
+	if windowSize > 0 {
+		if mode != "causal" {
+			panic("mlx: sliding-window SDPA requires causal mode")
+		}
+		mode, mask = "array", causalWindowMask(q, k, windowSize)
+	}
+
 	cMode := C.CString(mode)
 	defer C.free(unsafe.Pointer(cMode))
 
@@ -40,10 +47,22 @@ func FastScaledDotProductAttentionWithSinks(q, k, v *Array, scale float32, windo
 	}
 
 	out := New("FAST_SDPA")
-	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), C.int(windowSize), cMode, maskCtx, sinksCtx, C.bool(false), DefaultStream().ctx))
+	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), cMode, maskCtx, sinksCtx, C.bool(false), DefaultStream().ctx))
 	return out
 }
 
+// causalWindowMask mirrors MLX's causal sliding-window SDPA: with queries
+// aligned to the end of the keys, key j is visible to query i when
+// 0 <= i-j < window.
+func causalWindowMask(q, k *Array, window int) *Array {
+	qL, kL := q.Dim(2), k.Dim(2)
+	dist := Sub(
+		Arange(float64(kL-qL), float64(kL), 1, DTypeInt32).ExpandDims(1),
+		Arange(0, float64(kL), 1, DTypeInt32).ExpandDims(0),
+	)
+	return Where(dist.Less(FromValue(0)), FromValue(false), dist.Less(FromValue(window)))
+}
+
 type LayerNorm struct {
 	Weight *Array `weight:"weight"`
 	Bias   *Array `weight:"bias"`
