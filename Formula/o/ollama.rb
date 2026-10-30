class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.40.13",
      revision: "04088e7c9d41cba5d33bafbf788d87a465c79d5b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1df4d9077d226db7e02c40784ebabdbc99a90334f237b9c557eb7b1f00b07164"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5aed727346825cdad91bead60ac90b33a79901d7ea02d7ae09d44a6ab7a96d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26400b007bf0c1463137a9120606dde475244b64deadc9911f31ed01b5d03c28"
    sha256 cellar: :any,                 arm64_linux:       "40df1253638debefb6d714b89ffffc3d00cf4e35ec292cf325061e88f2507d7b"
    sha256 cellar: :any,                 x86_64_linux:      "b421a666b479d6f7e6436d91d7173d8c6e368eaf9d6d131d89673a58cf514831"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "dlpack" => :build
      depends_on "mlx-c" => :no_linkage
      depends_on "xgrammar" => :build

      # Build with the mlx-c 0.8.0 bindings for tagged MLX 0.32.4. Upstream targets a later MLX commit:
      # https://github.com/ollama/ollama/commit/66ab8482e08035a3238dff04a5739c4371c61bfe
      # `mlx_fast_scaled_dot_product_attention` has no `window_size` in mlx-c 0.8.0, so apply the window as a mask:
      # https://github.com/ollama/ollama/blob/v0.40.12/mlx/compat/mlx-c/0001-mlx-c-sdpa-window-size.patch
      patch :DATA
    end
  end

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b11963",
        revision: "39febd2adb947b70da35e95f9351b3bf58ad170a"

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

      # Structured output on the MLX engine; random weights only produce valid JSON when constrained
      resource "homebrew-test-mlx-config" do
        url "https://huggingface.co/stas/tiny-random-llama-2/resolve/3579d71fd57e04f5a364d824d3a2ec3e913dbb67/config.json"
        sha256 "9197475bfcc987a4f9361dbc22b33397b101372c137c228b6a6fd7e4adf21622"
      end
      resource "homebrew-test-mlx-weights" do
        url "https://huggingface.co/stas/tiny-random-llama-2/resolve/3579d71fd57e04f5a364d824d3a2ec3e913dbb67/model.safetensors"
        sha256 "852db1b39acb2336abc997440c6f6d6e4ab640f91e5e2aa9e2488d5794159d30"
      end
      resource "homebrew-test-mlx-tokenizer" do
        url "https://huggingface.co/stas/tiny-random-llama-2/resolve/3579d71fd57e04f5a364d824d3a2ec3e913dbb67/tokenizer.json"
        sha256 "0afe36ee1358ce1fa277f4eac935250bb90253ed5c27867eb6ff376ded7d1980"
      end
      %w[config weights tokenizer].each do |name|
        (testpath/"tiny").install resource("homebrew-test-mlx-#{name}")
      end
      (testpath/"Modelfile").write "FROM #{testpath}/tiny"

      pid = spawn bin/"ollama", "serve"
      begin
        sleep 3
        system bin/"ollama", "create", "tiny", "-f", testpath/"Modelfile"
        request = { model: "tiny", prompt: "hi", stream: false, format: { enum: ["ok"] } }
        response = shell_output("curl -s localhost:#{port}/api/generate -d '#{request.to_json}'")
        assert_equal '"ok"', JSON.parse(response)["response"]
      ensure
        Process.kill "TERM", pid
        Process.wait pid
      end
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
