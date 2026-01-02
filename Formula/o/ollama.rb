class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.5",
      revision: "7325791599409de52534429897481918717a9e85"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71110c338cdae29c28a2a53b63c7f5e50b90ef10338d8d1796abde10cc9fc96d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91de1a7590b3faf3a24bda696af207bec349162a9330099f82455782f3a5069b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c7c15a5b0dda5bd3f49907fcb38a02ce4fd23840faea36351aa9c0b54ddfa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6d458941e96770b169086afca1fc5caf25dcd18a6a2c6c43c228a58323bdc7a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "544482218e1f2c3131f10fe8c7e5aea364dc0f0895f0da98d82e47434e0040dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b55602eefe88c9deaf5b0ebd31ffcf774c3836a655e4cb78f7019259dcf5600"
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

  def caveats
    <<~EOS
      This formula builds Ollama without GPU acceleration
      (e.g. CUDA, ROCm, or Metal).

      If you require GPU support, please use the official installer:
        https://ollama.com/download
    EOS
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
