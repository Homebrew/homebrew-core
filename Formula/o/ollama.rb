class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.9.0",
      revision: "5f57b0ef4268a6bd9e8043d54c351a608a7e1bca"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035b6b23542d9d5026adaacfb87ab8fdc2d60a0b66c7989827e4d10302652a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f3f56dd30f3fe844fefb7d4dbbc25b4bc6ae284895dfe436a2660baeb730d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ceb1a2f1b4403255ae9411da4fda735f99e59b9e67c94c9aef96a0a4d6a5f65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52bb083a7065f2348057d8c54dafd2076181268fb35a68f7c26d7664188c7a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "1184ed42bb90871e08f15a5317b385177571e1ef79207bafe982652c4c1b18e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff4df83874ae07a5a41ba5a86c3bcf39fec319e57f310d139922deddbd82e72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15810b73c62982a9557ab7b1df77eac0cba93415fc9eedd2a7bba48f2279119"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
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
