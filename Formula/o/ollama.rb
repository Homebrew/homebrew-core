class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.6.5",
      revision: "0f3f9e353df96d4cfc40ac19114c782a57fe30f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a254b8770a46239022541b77cfc56c7af045adcfc7a15a575e35bebc3285009e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "805c78524649946efb2049711b994b390887866b54d47389be9b39e8436ac400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df693b2085e7e1b9cd28b75f2038dcda01ba40704785da73d73974364a7202b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fcea97c02bfae64b81044ffbd86141bbb741c098cb16bae5f3354e7127987f1"
    sha256 cellar: :any_skip_relocation, ventura:       "be716802921036544dda7f7b9e35b97dade83e41796cf08b88d8ea76506a44ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b35ad108ca3524c1f77e1e0c95e808dba6b385d06879471da1ba5197dc1895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6c34f919e8b138d863b12971fec2246d38a1e66b21c838ef42633d6216fe45"
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
