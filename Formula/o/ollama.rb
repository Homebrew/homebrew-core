class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.6.4",
      revision: "b51e0f397ced70bbfa7f22e9b3c94953967cb8e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "944c5ae9cffdb8c1618f6121a97107682df9bd9added6a33f553008adeed15da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3609c6f7d775ad73a1cac81bccc35b3390ac750bc61d4ed538ea44bcb907b65b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06905028e25b7530132e5d3dd0f169cab8c44b85d53ccd6b2a43c9ddc8f6c02b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b697d53b586920f574068fac667d0b1480ac0b3b7f5dc6c771fd8e1d85c1620"
    sha256 cellar: :any_skip_relocation, ventura:       "29de1f2e2e68517c55fbb356423297ee740aa57837d26e51abcf54ee2b4c798e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8498e02296ba69cc35aa039cf8418d9ad02a1d42827dbf1bcf529efd4723941b"
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

    # Install shell completions
    generate_completions_from_executable(bin/"ollama", "--shell-completion")
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
