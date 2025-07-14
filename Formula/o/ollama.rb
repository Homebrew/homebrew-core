class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.9.6",
      revision: "43107b15b9bcff51ef1c5391c273fd1a747f6d0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a6a49257ebcf45d1e075881feeee8e7fbaf83ad23b9318a5d85f64ba1e608f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b9035c6ee9986cf57c1dcbce54f5b743d5ce5145f86de937cecd6eadd84889"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ec0f3ffc3b1d633861abaa89cd1f2a29bd7920d9b0b8d9ab7e8c30c92efb7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "813cc8a554703501df3fc1ed0537a6c02f8a644559bc7e90e9efd41a0cfd174f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc06dae30ec227baf32a98a121323b436882ecc86bdc9cd28407e11966beae4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81678ab3c63b0e3bfc87bf7daa06a62cedb7e5f18b8526df6da4af51f99b865d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3feef789dfa28a6db0699564900a3e20d370398253653ce3056ea006b23ef49b"
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
