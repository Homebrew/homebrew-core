class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.34.2",
      revision: "dfabde4539e42ba1e1eab50a3a50b88aea7958a0"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d993723f4446c2b4e4202a1291e5b9c219c5e4a409de7cea29db8b68b210aada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "832c1987856f8e13b5b3be96055960d0667e07ce91685dce6148638007d918df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5740749e799819877ac2905e3be323a82bb588266313f620b1c09fa9046c7a98"
    sha256 cellar: :any,                 arm64_linux:       "63c1a9712288c4fed6e12008b44480bc49420f8c0e6b3239d0a0f53d23a4e681"
    sha256 cellar: :any,                 x86_64_linux:      "0b9b2320b16fef168ade06730c34084b6fa1e0462cbfb4007b59c05d35eac14b"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Build with the mlx-c bindings for tagged MLX 0.32.1. Upstream targets a later MLX commit:
      # https://github.com/ollama/ollama/commit/0bb09259203ff8f6d361faae1d40c4f83d2a99f7
      # `mlx_cumsum_axis` only exists after mlx-c commit for MLX 0.32.2:
      # https://github.com/ml-explore/mlx-c/commit/d4afaec5cc5c9ffbe58f37fdc038b2faaedc6e70
      # `mlx_gather_qmm` has no `global_scale` in MLX 0.32.1, so always use the wrapper fallback:
      # https://github.com/ollama/ollama/blob/v0.34.1/mlx/compat/0001-mlx-c-qmm-global-scale.patch
      patch :DATA
    end
  end

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b10969",
        revision: "391fac16460f15233a7740550d858ac96df3419d"

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

    # b10630: tools/tuning hardcodes CMAKE_SOURCE_DIR, which is the ollama
    # build root under FetchContent; retarget to llama.cpp's own ggml-metal dir.
    # Remove when llama.cpp fixes it upstream:
    # https://github.com/ggml-org/llama.cpp/issues/28114
    inreplace llama_source_dir/"tools/tuning/CMakeLists.txt",
              "${CMAKE_SOURCE_DIR}/ggml/src/ggml-metal",
              "${CMAKE_CURRENT_SOURCE_DIR}/../../ggml/src/ggml-metal"

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
index 27d5724..f38a670 100644
--- a/mlx/fast.go
+++ b/mlx/fast.go
@@ -24 +24 @@ func FastScaledDotProductAttention(q, k, v *Array, scale float32, mode string, m
-	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), cMode, maskCtx, sinks.ctx, C.bool(false), DefaultStream().ctx))
+	mlxCheck(C.mlx_fast_scaled_dot_product_attention(&out.ctx, q.ctx, k.ctx, v.ctx, C.float(scale), cMode, maskCtx, sinks.ctx, DefaultStream().ctx))
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
