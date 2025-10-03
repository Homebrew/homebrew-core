class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.3",
      revision: "b04e46da3ebca69a2b1216b3943d8a463e8b4a14"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a6a57f9c38747d3f67096591ffd659a5a14d1ef41f3dcff070a8ca10ea3905a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1918cad7db829610da27ea2d17809a34deaefd14df463f11b8a3bb2a63d7b69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "725e05852a0b452b4a18072bbdeb7e1fc48addab5e431ce9b1851b85ff557ea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2ceb8fbb0bfc4c88b86e0690b9588d6c4a4924c8f32f3e95a5ad1f94a62e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ad1b8486bb4c24643c574244a388ac7138fb18bb31a3e0796b1fa07644742d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19891aef63765e1c328b0d2dec0cf2eeccfa6c7451b90bdc1a004caed8b2db7"
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
