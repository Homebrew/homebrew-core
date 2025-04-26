class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.6.6",
      revision: "88738b357bcd25eea860b59bf7de2f6b94cfc352"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2efbc07838b9622892ae76974322c8dbf6e64e02c9d1f0c388dce489774300b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c035ea0d9cf27260f656dd8a1607606413cf27f0b7e15b82fa1125348a805f77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08b9e1db5964261d893cfc37475308e2829cf018664ecef6e156af98ae5287de"
    sha256 cellar: :any_skip_relocation, sonoma:        "0656bc6e1059e8427e94bc724ae04c0fd96abddcff5d594a77cfe532897c65bf"
    sha256 cellar: :any_skip_relocation, ventura:       "f66095654048688eac2362ebeec5c950ff91cdf87a1d4231cb9c389b8574a695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21924ff97082a9cf73e78c5254bf443e5d0f2344ea9bf866288841a852a52269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36976df9b586b4a262d0591e79558769d4a9e05dd459a0039be960cf5b66e295"
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
