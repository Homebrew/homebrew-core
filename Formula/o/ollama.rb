class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.0",
      revision: "604e43b28d12677c96675ba368eee20a2bed2c24"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e0b5bcbf1ebbf67fa3934a81a2eaf1dafececb1f1edf9386c151ba4a8d2021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b438017748b8e4c0a6a8cfb5bd7d1d407a91666f4c21c6dcb09634f3f58ae063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a459ce8174b89990d4ac57a2a7692fbaf29a17e9256d285991158be33bb79fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50306fa8d363c80a1ceb7122664d842e34e432d82b0c685e95ad3f8a4fa32c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e970304af2d5d98d2c41c50a8b18d67e25a64cac7f16abcb598d78f3776222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a4e62f3ec1ceb91f10645ee4a4c3c75522288436160e400d5c02faa1f087e7"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
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

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
