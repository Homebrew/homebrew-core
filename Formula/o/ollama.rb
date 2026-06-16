class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.30.8",
      revision: "12e04379cd5a9a2f150104a02c5761213f4be777"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "770eb48c5e285721dc8eee8c400a8cede0fe85d473b4abbe9d273e90c25ba3e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df3b0e75c25913e8ceac758d3a8c702b50d395f7a25aa2b3b7b2e983e59f0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37eb466808d5b26c8ad36501bfde72362b5e67744983b56ed1ebdaacce22916f"
    sha256 cellar: :any,                 sonoma:        "0bc79c0fc93af641ee9294ed8041053c55291493f31bec010dedcdb97ad03d81"
    sha256 cellar: :any,                 arm64_linux:   "a4282739f003f4208b8fcb61704bfe590637feb1d854e11ec350f6b096778041"
    sha256 cellar: :any,                 x86_64_linux:  "07ed11389006c97e40390363aeb2cc204c9657aa23c4a3a3cb48292b5d3e13f8"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      if build.stable?
        # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
        # upstream pr ref, https://github.com/ollama/ollama/pull/14201
        patch do
          url "https://github.com/ollama/ollama/commit/c051122297824c223454b82f4af3afe94379e6dd.patch?full_index=1"
          sha256 "a22665cd1acec84f6bb53c84dd9a40f7001f2b1cbe2253aed3967b4401cde6a0"
        end
      end
    end
  end

  on_linux do
    depends_on "shaderc" => :build
    depends_on "spirv-headers" => :build
    depends_on "vulkan-loader"
  end

  conflicts_with cask: "ollama-app"

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b9509",
        revision: "6f3a9f3dee3c27545371044a3a38005721ac8a8e"

    livecheck do
      url "https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/LLAMA_CPP_VERSION"
      regex(/^v?b(\d+)$/i)
    end

    # fix: don't build AMX by default with Apple clang
    patch do
      url "https://github.com/ggml-org/llama.cpp/commit/1f92170dc9d4620b5aadb9bacba502c726e5b587.patch?full_index=1"
      sha256 "1e51afe4b8cfed5653289270064370d926258b5bbd662a93eac240d7a37f2735"
    end
  end

  def install
    # Build llama-server
    llama_source_dir = buildpath/"llama.cpp"
    llama_source_dir.install resource("llama.cpp")

    if OS.linux?
      inreplace "llama/server/CMakeLists.txt",
                'set(CMAKE_INSTALL_RPATH "$ORIGIN")',
                'set(CMAKE_INSTALL_RPATH "$ORIGIN;$ORIGIN/..")'
    end

    presets = [(OS.mac? && Hardware::CPU.arm?) ? "darwin" : "cpu"]
    presets << "vulkan" if OS.linux?

    install_rpaths = [loader_path]
    install_rpaths << "#{loader_path}/.." if OS.linux?
    install_rpaths << rpath(target: Formula["vulkan-loader"].opt_lib) if OS.linux?

    args = %W[
      -DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP=#{llama_source_dir}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{install_rpaths.join(";")}
    ]

    presets.each do |preset|
      build_dir = "llama-server-#{preset}"
      system "cmake", "-S", "llama/server", "-B", build_dir,
                      "--preset", preset, *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", build_dir
      system "cmake", "--install", build_dir, "--component", "llama-server"
    end

    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    mlx_args = []

    # Flags for MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      mlx_rpath = rpath(target: Formula["mlx-c"].opt_lib)
      ldflags << "-extldflags '-Wl,-rpath,#{mlx_rpath}'"
      mlx_args << "-tags=mlx"
    end

    system "go", "generate", *mlx_args, "./x/imagegen/mlx"
    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"

    # The mlx runner dlopens MLX libraries from `<exe_dir>/lib/ollama/mlx_*/`.
    # Using `opt` keeps the link stable across mlx-c version bumps.
    if OS.mac? && Hardware::CPU.arm?
      (libexec/"lib/ollama/mlx_metal_v3").mkpath
      ln_sf Formula["mlx-c"].opt_lib/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
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
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1")
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output
    end

    if OS.linux?
      vulkan_backend = libexec/"lib/ollama/vulkan"/shared_library("libggml-vulkan")
      assert_path_exists vulkan_backend
      ldd_output = shell_output("ldd #{vulkan_backend}")
      assert_match "libvulkan", ldd_output
      refute_match "not found", ldd_output
    end

    # Check llama-server binary
    require "pty"

    output = +""
    r, _w, pid = PTY.spawn(libexec/"lib/ollama/llama-server")
    begin
      timeout = Time.now + 20
      until output.include?("starting router server")
        raise "timed out waiting for llama-server to start\n#{output}" if Time.now > timeout

        begin
          output << r.read_nonblock(1024)
        rescue IO::WaitReadable
          sleep 0.1
        rescue EOFError
          break
        end
      end

      assert_match "starting router server", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
