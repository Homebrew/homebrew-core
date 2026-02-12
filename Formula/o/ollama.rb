class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.16.0",
      revision: "f8dc7c9f54a753d2c6d3410936e73486f9bf463d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c257f58966147fba629862b1018d81b703f89aff6b7e8c3488454846d0c2379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d82c3d11982335459cb1e7220362d305bee9c012b28cc5142d556fec439e7a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "596d1804c196fb298b6d623dc3f3d41145e93ea19c781513f40d5cad4f8cee2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b66c68927f6c2f93374140d88022c3fb872fc57996b4d3b5aa160192258d30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437bee0c92fa3b0db620b1f3ac53c5e275a2ff82f75a437050832f1efa84e11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226dd57f6c2434f7b8f777d195b8c4d44e072300121218853d6a1cabede5a6dd"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Fixes mlx wrapper generation with system-installed mlx-c headers.
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

    system "go", "generate", *mlx_args, "./..."
    system "go", "build", *mlx_args, *std_go_args(ldflags:)
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
