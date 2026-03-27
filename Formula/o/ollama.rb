class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.18.3",
      revision: "26b9f53f8ef1934f9df9fc5e39bbe701921efd9a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3db512ac4da41f17a0e6d349c077cc95ad3be4c6f31bd697a4b2025474fcc0cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c95c5d65cb25244e8e02f329c639c6af46b0a301bcc18ca265e6fadb47abd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d8d4d786a3f41e8603a1293e845cfe2618c6a47036bd8bd17caf8b6cf60672"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd887ec2d3239a0550e4016ea3ec637f75e216ed311fa68c349870564429f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "790800462a2fc94e5d806498056aabfcf8f0be8f71ae2d6941662f838db8b258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e32f970fcf2f74ba38f0727848e8761252a25394b8e4a078aedbad5849530ac"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
      # upstream pr ref, https://github.com/ollama/ollama/pull/14201
      if build.stable?
        patch do
          url "https://github.com/ollama/ollama/commit/c051122297824c223454b82f4af3afe94379e6dd.patch?full_index=1"
          sha256 "a22665cd1acec84f6bb53c84dd9a40f7001f2b1cbe2253aed3967b4401cde6a0"
        end
      end
    end
  end

  conflicts_with cask: "ollama-app"

  def install
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
    system "go", "build", *mlx_args, *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ollama", shell_parameter_format: :cobra)
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
  end
end
