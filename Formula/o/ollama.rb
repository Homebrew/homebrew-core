class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.3.14",
      revision: "f2890a4494f9fb3722ee7a4c506252362d1eab65"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad7ab2bba4691dd42cb669ab7c9e22930a404da2b7dd256400a1aab8678d1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6057edec2a88a59a8f1da2e633433938838fef5df6b3b1a3ee8e0efac4285552"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a00d8116e4925f44eaafd95181e476cb3cd06d52ecc83d591d6fad0a7f71b294"
    sha256 cellar: :any_skip_relocation, sonoma:        "3064acfc34eedc3e4235f84ebc0cd8b8f636970ae772306a1d3df2f4d6de577e"
    sha256 cellar: :any_skip_relocation, ventura:       "98e39d2e5af94ca268f0c3f8fa7ff73e5b4c9db4c8ee6239fa372e098d5128af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57c6e116d85ea1b183cf8d391e17db85c10b08ad00913e35606845cbc46b3b4"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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
