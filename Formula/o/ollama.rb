class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.33.3",
      revision: "b79067b0db7417f20108363bc22adb97f35c966a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1a29b4e989550de8e83c4ecef47f89731803ac1c409861c45dcbfd1783841a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b396764ad303151e9a84a8cde25ee979d4f8570207124766bdb9e47c1980b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9cce526e25c4f466a45b1c9ccbf8193540fce1e702a5a7dc7c933be0280287"
    sha256 cellar: :any,                 arm64_linux:   "35f90dcc5ddc555768668263f03138a78d54c8e6c51d6942bb564cf49cf39f4f"
    sha256 cellar: :any,                 x86_64_linux:  "b35346c616abaaed4eea9a3555231e9fd6c270cd89944d2573b2a1d9fc4be959"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      # MLX links fmt header-only (mirrors the `mlx` formula).
      depends_on "fmt" => :build
    end
  end

  conflicts_with cask: "ollama-app"

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b10760",
        revision: "0f3a71be15af836d277c9f918adfafb45732677e"

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

  # MLX, MLX-C and XGrammar are pinned by Ollama upstream (MLX_VERSION,
  # MLX_C_VERSION and cmake/mlx/CMakeLists.txt at the tag above). Building the
  # MLX runner from these pinned sources keeps the built libmlxc, the vendored
  # Go wrapper headers and the runner consistent. The `mlx`/`mlx-c` formulae
  # track tagged MLX releases which have repeatedly drifted from these pins
  # (homebrew-core#266704, homebrew-core#302645, ollama/ollama#15433, #15882).
  #
  # Bump these in lockstep with `version` at each release; the livechecks below
  # read Ollama's own pin files from the latest tag so `brew bump` reports drift
  # (same scheme as the `llama.cpp` resource above).
  resource "mlx" do
    url "https://github.com/ml-explore/mlx.git",
        revision: "37c26e5755da637255d57ea34b4879196a485301"
    version "37c26e5755da637255d57ea34b4879196a485301"
    livecheck do
      url "https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/MLX_VERSION"
      regex(/^([0-9a-f]{40})$/im)
    end
  end

  resource "mlx-c" do
    url "https://github.com/ml-explore/mlx-c.git",
        revision: "c74db5307cc8ce122f48d97ef951b30578674e7f"
    version "c74db5307cc8ce122f48d97ef951b30578674e7f"
    livecheck do
      url "https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/MLX_C_VERSION"
      regex(/^([0-9a-f]{40})$/im)
    end
  end

  resource "xgrammar" do
    url "https://github.com/mlc-ai/xgrammar.git",
        tag:      "v0.2.5",
        revision: "2ea71da4ccb997a06928c9fb69b99f330da56697"
    livecheck do
      url "https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/cmake/mlx/CMakeLists.txt"
      regex(/XGRAMMAR_VERSION (v\S+)/)
    end
  end

  # nlohmann/json bundle required by the MLX and JACCL CMake builds at the pinned
  # revision above (same URL as MLX's own FetchContent declaration).
  resource "json" do
    url "https://github.com/nlohmann/json/releases/download/v3.11.3/json.tar.xz"
    sha256 "d6c65aca6b1ed68e7a182f4757257b107ae403032760ed6ef121c9d55e81757d"
  end

  # Apple's metal-cpp headers required by the MLX Metal backend
  # (URL from the MLX CMakeLists at the pinned revision above).
  resource "metal-cpp" do
    url "https://developer.apple.com/metal/cpp/files/metal-cpp_26.zip"
    sha256 "4df3c078b9aadcb516212e9cb03004cbc5ce9a3e9c068fa3144d021db585a3a4"
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

    # Build the MLX Metal variants from Ollama's pinned sources (Apple silicon only).
    #
    # `mlx_metal_v3` (deployment target 14.0) supports macOS 14+, while
    # `mlx_metal_v4` (deployment target 26.2) enables Metal 4 and the M5
    # Neural Accelerator (NAX) kernels on macOS 26.2+. The Ollama runner picks
    # the highest compatible variant at runtime, mirroring the layout of the
    # official upstream distribution.
    if OS.mac? && Hardware::CPU.arm?
      mlx_source_dir = buildpath/"mlx"
      mlx_source_dir.install resource("mlx")
      mlx_c_source_dir = buildpath/"mlx-c"
      mlx_c_source_dir.install resource("mlx-c")
      xgrammar_source_dir = buildpath/"xgrammar"
      xgrammar_source_dir.install resource("xgrammar")
      metal_cpp_source_dir = buildpath/"metal-cpp"
      metal_cpp_source_dir.install resource("metal-cpp")
      json_source_dir = buildpath/"json"
      json_source_dir.install resource("json")

      variants = ["mlx_metal_v3"]
      variants << "mlx_metal_v4" if build_metal_v4?

      variants.each do |variant|
        args = %W[
          --preset #{variant}
          -DFETCHCONTENT_SOURCE_DIR_MLX=#{mlx_source_dir}
          -DFETCHCONTENT_SOURCE_DIR_MLX-C=#{mlx_c_source_dir}
          -DFETCHCONTENT_SOURCE_DIR_XGRAMMAR=#{xgrammar_source_dir}
          -DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{metal_cpp_source_dir}
          -DFETCHCONTENT_SOURCE_DIR_JSON=#{json_source_dir}
          -DUSE_SYSTEM_FMT=ON
          -DFETCHCONTENT_FULLY_DISCONNECTED=ON
        ]
        system "cmake", "-S", "cmake/mlx", "-B", "build/#{variant}", *args, *std_cmake_args(install_prefix: libexec)
        system "cmake", "--build", "build/#{variant}"
        system "cmake", "--install", "build/#{variant}", "--component", "MLX"
      end
    end

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
      mlx_args << "-tags=mlx"

      # Generate the Go MLX wrappers from the vendored MLX-C headers, which
      # match the pinned mlx-c resource the variants above were built from.
      system "go", "generate", *mlx_args, "./x/mlxrunner/mlx"
    end

    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"
  end

  # `mlx_metal_v4` requires the macOS 26.2 SDK at build time (MLX drops the
  # NAX kernels and errors out otherwise).
  def build_metal_v4?
    macos_version = Version.new(MacOS.full_version.to_s)
    return false if macos_version < "26"

    sdk_version = Version.new(Utils.safe_popen_read("xcrun", "--show-sdk-version").strip)
    sdk_version >= "26.2"
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

  test do
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
      # The captured output can contain non-UTF-8 bytes (dyld/sandbox noise on
      # some hosts), so scrub before matching.
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1").scrub
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output

      mlx_v3_dir = libexec/"lib/ollama/mlx_metal_v3"
      assert_path_exists mlx_v3_dir/"libmlxc.dylib"
      assert_path_exists mlx_v3_dir/"libollama_xgrammar.dylib"

      if build_metal_v4?
        mlx_v4_dir = libexec/"lib/ollama/mlx_metal_v4"
        assert_path_exists mlx_v4_dir/"libmlxc.dylib"
        # The v4 metallib must carry the M5 Neural Accelerator (NAX) kernels;
        # without them M5 MLX prefill regresses ~3x (ollama/ollama#17884).
        # Read as binary: the metallib is a Mach-O file with invalid UTF-8 bytes.
        assert_match "steel_gemm_fused_nax", (mlx_v4_dir/"mlx.metallib").binread
      end
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
