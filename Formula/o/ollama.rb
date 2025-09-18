class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.11",
      revision: "92b96d54efd6b49322b7cf046f9a0dc16b00cd0a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd7e4d0b29f8d01e61859ce4f26ec2b63794b4c9ba6d7361dfaefac51f0001e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a7f013185377a63407a9b4df8e113130c79a8008c3738105652cbe2383d00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c215c34d9a198813e6ca1845482a92f3920e0e55426c8da7286a4ab0e1668e74"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b68586d301fb80c8d7f4bc82d50b8a1766e4078d79d78c610b12fc50d1bd75c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ce2209cb17623133042d6433b0b095f558d47b87b1c8bd2bf5a1927ef9a3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e36fb8db4a17339659862b11e32b1d0fdf1a6f0fc158f760f53cf71baa192a"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

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
