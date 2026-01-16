class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.14.1",
      revision: "4adb9cf4bbf21486113eb13680b8be6a08fc5d0e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "323cfb77be3a7becb6065f963a031e8733058ea6b077e9476e0307178239411b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ea32e7d9495aea7b09d4f6ff69893d427bf99085b075d88af825e3171a6b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c0b5f53e5322abe6e9d1e797e6a6b7a3db2c996e2856af683dff2d672589cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fbaba34b0a817dab1cf76f7cfa15c99c802bc0c951e8451565fd8cc13714c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec3816ed1f607c5e4f926733f385837e2efd62cac8df14c23a29bfe28d32ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31e227b801560b3699105857f37e9730315dfe8d1400cbb9bd8b2bf1de305217"
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
