class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.34.4",
      revision: "b2da9e468af2479058ae18c6d908ed29de410684"
  license "MIT"
  revision 1
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3dec6368ea875450deb80d5073621f8e4e63e905ae054afd5188131d7b12c9b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39056e8b6030e007cb9b94ae727b946000c3290e98de239fba2551618f635abc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5edd8fe607b9e6b6f67fa8db95d704eb748c165f9cb6ce0ad5c850682dce2d4e"
    sha256 cellar: :any,                 arm64_linux:       "a8626384aa7767fcb5c96122283b6c65f366e4272430ba9a27c11135aa780a75"
    sha256 cellar: :any,                 x86_64_linux:      "9714a43bfb3186cab5d9a555375c433944a7ae4836a732bbbcefc8b9d7b3b604"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "dlpack" => :build
      depends_on "mlx-c" => :no_linkage
      depends_on "xgrammar" => :build

      # Build with the mlx-c bindings for tagged MLX 0.32.1. Upstream targets a later MLX commit:
      # https://github.com/ollama/ollama/commit/0bb09259203ff8f6d361faae1d40c4f83d2a99f7
      # `mlx_cumsum_axis` only exists after mlx-c commit for MLX 0.32.2:
      # https://github.com/ml-explore/mlx-c/commit/d4afaec5cc5c9ffbe58f37fdc038b2faaedc6e70
      # `mlx_gather_qmm` has no `global_scale` in MLX 0.32.1, so always use the wrapper fallback:
      # https://github.com/ollama/ollama/blob/v0.34.1/mlx/compat/0001-mlx-c-qmm-global-scale.patch
      # `mlx_fast_gated_delta_update` needs MLX newer than 0.32.1, so always use Ollama's own kernel:
      # https://github.com/ollama/ollama/blob/v0.34.4/mlx/compat/mlx-c/0002-fast-gated-delta-update.patch
      patch :DATA
    end
  end

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b11081",
        revision: "161755f29e415e2c33efe906e91843c068efd664"

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

  # downloads go modules in install and runs a server in test
  deny_network_access! :postinstall

  def install
    # Build llama-server
    llama_source_dir = buildpath/"llama.cpp"
    llama_source_dir.install resource("llama.cpp")

    preset = (OS.mac? && Hardware::CPU.arm?) ? "darwin" : "cpu"

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
      # `mlx` bottles on macOS 26+ carry the NAX (Metal 4) kernels, and the
      # runner skips `mlx_metal_v4` directories on older systems.
      metal_dir = if MacOS.version >= :tahoe
        "lib/ollama/mlx_metal_v4"
      else
        "lib/ollama/mlx_metal_v3"
      end
      (libexec/metal_dir).mkpath
      ln_sf formula_opt_lib("mlx-c")/"libmlxc.dylib", libexec/metal_dir/"libmlxc.dylib"

      # The runner loads the structured output library from next to libmlxc
      system "cmake", "-S", "mlxrunner/xgrammar/native", "-B", "build-xgrammar",
                      "-DXGRAMMAR_VERSION=v#{Formula["xgrammar"].version}",
                      *std_cmake_args(install_prefix: libexec, install_libdir: metal_dir)
      system "cmake", "--build", "build-xgrammar"
      system "cmake", "--install", "build-xgrammar"
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
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1").scrub
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output

      metal_dir = if MacOS.version >= :tahoe
        libexec/"lib/ollama/mlx_metal_v4"
      else
        libexec/"lib/ollama/mlx_metal_v3"
      end

      # Compile a JSON schema grammar with the structured output library
      (testpath/"xgrammar.c").write <<~C
        #include <stdint.h>
        #include <stdio.h>
        #include <string.h>

        const char *ollama_xgrammar_last_error(void);
        int ollama_xgrammar_compiler_new(const char *, size_t, const uint64_t *, size_t, int32_t,
                                         const int32_t *, size_t, int32_t, int64_t, void **);
        int ollama_xgrammar_matcher_new(void *, const char *, size_t, void **);

        int main(void) {
          const uint64_t offsets[] = {4, 9};
          const int32_t stop = 1;
          const char tag[] = "{\\"type\\":\\"structural_tag\\",\\"format\\":"
                             "{\\"type\\":\\"json_schema\\",\\"json_schema\\":{\\"type\\":\\"boolean\\"}}}";
          void *compiler, *matcher;
          if (ollama_xgrammar_compiler_new("true<eos>", 9, offsets, 2, 2, &stop, 1, 1, 0, &compiler) ||
              ollama_xgrammar_matcher_new(compiler, tag, strlen(tag), &matcher)) {
            fprintf(stderr, "%s\\n", ollama_xgrammar_last_error());
            return 1;
          }
          return 0;
        }
      C
      system ENV.cc, "xgrammar.c", "-L#{metal_dir}", "-lollama_xgrammar", "-Wl,-rpath,#{metal_dir}", "-o", "xgrammar"
      system "./xgrammar"
    end

    # Check llama-server binary; it needs a model as upstream builds it without router mode support
    resource "homebrew-test-model" do
      url "https://huggingface.co/ggml-org/models/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf"
      sha256 "270cba1bd5109f42d03350f60406024560464db173c0e387d91f0426d3bd256d"
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
diff --git a/mlx/fast.go b/mlx/fast.go
--- a/mlx/fast.go
+++ b/mlx/fast.go
@@ -21,7 +21,7 @@
 	}
 
 	out := New("FAST_SDPA")
-	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), cMode, maskCtx, sinks.ctx, C.bool(false), DefaultStream().ctx))
+	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), cMode, maskCtx, sinks.ctx, DefaultStream().ctx))
 	return out
 }
 
@@ -30,38 +30,6 @@
 	Bias   *Array `weight:"bias"`
 }
 
-// fastGatedDeltaUpdate applies MLX's gated-delta recurrence and returns its
-// per-token outputs and final float32 state. state and mask may be nil.
-func fastGatedDeltaUpdate(q, k, v, gates, beta, state, mask *Array) (y, nextState *Array) {
-	outVec := mlxCheck(C.mlx_vector_array_new())
-	defer freeVectorArray(outVec)
-
-	var stateCtx, maskCtx C.mlx_array
-	if state != nil {
-		stateCtx = state.ctx
-	}
-	if mask != nil {
-		maskCtx = mask.ctx
-	}
-
-	mlxCheck(C.mlx_fast_gated_delta_update(
-		&outVec,
-		q.ctx,
-		k.ctx,
-		v.ctx,
-		gates.ctx,
-		beta.ctx,
-		stateCtx,
-		maskCtx,
-		DefaultStream().ctx))
-
-	y = New("FAST_GATED_DELTA_Y")
-	nextState = New("FAST_GATED_DELTA_STATE")
-	mlxCheck(C.mlx_vector_array_get(&y.ctx, outVec, C.size_t(0)))
-	mlxCheck(C.mlx_vector_array_get(&nextState.ctx, outVec, C.size_t(1)))
-	return y, nextState
-}
-
 func (r *LayerNorm) Forward(x *Array, eps float32) *Array {
 	out := New("FAST_LAYERNORM")
 	mlxCheck(C.mlx_fast_layer_norm(&out.ctx, x.ctx, r.Weight.ctx, r.Bias.ctx, C.float(eps), DefaultStream().ctx))
diff --git a/mlx/ops.go b/mlx/ops.go
--- a/mlx/ops.go
+++ b/mlx/ops.go
@@ -103,7 +103,6 @@
 
 func (t *Array) Cumsum(axis int, reverse, inclusive bool) *Array {
 	out := New("CUMSUM")
-	optDtype := C.mlx_optional_dtype{has_value: false}
-	mlxCheck(C.mlx_cumsum_axis(&out.ctx, t.ctx, C.int(axis), C.bool(reverse), C.bool(inclusive), optDtype, DefaultStream().ctx))
+	mlxCheck(C.mlx_cumsum(&out.ctx, t.ctx, C.int(axis), C.bool(reverse), C.bool(inclusive), DefaultStream().ctx))
 	return out
 }
diff --git a/mlx/ops_extra.go b/mlx/ops_extra.go
--- a/mlx/ops_extra.go
+++ b/mlx/ops_extra.go
@@ -122,7 +122,7 @@
 	optGroupSize := C.mlx_optional_int{value: C.int(groupSize), has_value: true}
 	optBits := C.mlx_optional_int{value: C.int(bits), has_value: true}
 
-	var b, lhs, rhs, gs C.mlx_array
+	var b, lhs, rhs C.mlx_array
 	if biases != nil {
 		b = biases.ctx
 	}
@@ -134,13 +134,10 @@
 	}
 	// The wrapper fallback needs rhs indices to map output rows to experts;
 	// without them the native path reports the unsupported combination.
-	applyWrapperScale := globalScale != nil && !MetalIsAvailable() && rhsIndices != nil
-	if globalScale != nil && !applyWrapperScale {
-		gs = globalScale.ctx
-	}
+	applyWrapperScale := globalScale != nil
 
 	out := New("GATHER_QMM")
-	mlxCheck(C.mlx_gather_qmm(&out.ctx, x.ctx, w.ctx, scales.ctx, b, lhs, rhs, C.bool(transpose), optGroupSize, optBits, cMode, gs, C.bool(sortedIndices), DefaultStream().ctx))
+	mlxCheck(C.mlx_gather_qmm(&out.ctx, x.ctx, w.ctx, scales.ctx, b, lhs, rhs, C.bool(transpose), optGroupSize, optBits, cMode, C.bool(sortedIndices), DefaultStream().ctx))
 	if applyWrapperScale {
 		out = mulGatherQMMGlobalScale(out, globalScale, rhsIndices)
 	}
diff --git a/mlx/gated_delta.go b/mlx/gated_delta.go
--- a/mlx/gated_delta.go
+++ b/mlx/gated_delta.go
@@ -298,9 +298,6 @@
 // directly.
 func gatedDeltaRecurrence(q, k, v, g, beta, state *Array) (y, nextState *Array) {
 	if dims, ok := resolveGatedDeltaRecurrenceDims(q, k, v, g, beta, state); ok {
-		if supportsFastGatedDeltaUpdate(dims) {
-			return fastGatedDeltaUpdate(q, k, v, g, beta, state, nil)
-		}
 		outs := gatedDeltaRecurrenceKernel.run(gpuLaunch{
 			dtypes: []gpuDTypeArg{{"InT", q.DType()}, {"StT", state.DType()}},
 			ints:   []gpuIntArg{{"Dk", dims.Dk}, {"Dv", dims.Dv}, {"Hk", dims.Hk}, {"Hv", dims.Hv}},
