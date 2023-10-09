class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.1",
      revision: "1852755154a8f82cc2dcb01c37159340a55347ca"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a62c639d203568b6abd871dcd0451615ea88130a85c8fbe3b535a06997f36224"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "476888c4759b853e10f773c657f36edca8cb58c66b1a57f789346a155c738418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "388a0686e067e599b05507d2c05afb718c4b2fabe0a93b83df50144d41713d1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "33d7dc247495a9e78a7152c9c9ee5e2955e859c0274ca7725ba31e0f87dd8cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "3e53b91608d665171ba15a1038bd479026e7964d6e5d1be56201a93075d64bad"
    sha256 cellar: :any_skip_relocation, monterey:       "1239e41c35ca2d0164f50071b53ab8040f7bd2e5ce2febdeef5c436986f6113a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d454923d5b1600e3ab57aaee76a1845b03c8d37a90afdf1294d7ef891ce044"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
