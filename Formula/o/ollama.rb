class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.0",
      revision: "9f3a37fd36bf1c46cc86a47bc5372535f8ee3547"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "562148415554ad98622f28e8a8fee6aa3c52e07ae410d2ef3d617d7d33f6aa2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e831359fa814a3c288117de30b07dee55c5cd515b5b8e1c0488b2f357e58231a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f80996b14fbb8296ad3732929b9a01ebd3446486be1a94ec2759fa497c2b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38eccbc257df16d4f6983ec62733c2818f025c508aaff476ac48897a52d8ea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379c6df03690e9ca67ac82cdcc516eb77028a05baac1a2e3315b5cfaac487519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0802f4dce979507cf4c9235f778b76613101fc37dd6fc9aac6a9fc4754968d0"
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
