class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.16.2",
      revision: "d18dcd77755b55c9d761e483abee17d1e2b6c58c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d52fe51fecd3460ccb7e64dddd6d0f331bc8c5a37b731ef4271cda2c1aa07e7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2043e82abe26920e3245e9a20176a3e3b189a8bb9d3f5a48c29658815cde74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a99c2ef885a518a926a5e2f6b7defd24ded5af4840c14d975df8dce28b12e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd3ae857b600231baab1b6bec1f1476c53214d322900fc6633ae7e2001d3465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e074c738946bb907b278b9f672089f16d2c7a7ed5f616bf0abcc982976dd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d139cc5f840be747fbefc3b636e99389cdcafadd149d4dcdaf2b988c147737"
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

    if OS.mac? && Hardware::CPU.arm?
      # Temporary compatibility workaround for mlx-c 0.5.x.
      # Introduced by MLX runner generation in https://github.com/ollama/ollama/pull/14185
      # Upstream tracking issue https://github.com/ollama/ollama/issues/14298
      # Drop only this symbol until upstream syncs generated bindings.
      inreplace "x/mlxrunner/mlx/generated.h" do |s|
        s.gsub!("\nextern mlx_metal_device_info_t (*mlx_metal_device_info_)(void);\n", "\n")
        s.gsub!(
          <<~C,

            static inline mlx_metal_device_info_t mlx_metal_device_info(void) {
                return mlx_metal_device_info_();
            }
          C
          "\n",
        )
      end
      inreplace "x/mlxrunner/mlx/generated.c" do |s|
        s.gsub!("mlx_metal_device_info_t (*mlx_metal_device_info_)(void) = NULL;\n", "")
        s.gsub!("    CHECK_LOAD(handle, mlx_metal_device_info);\n", "")
      end
    end

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
