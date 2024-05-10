class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.34",
      revision: "adeb40eaf29039b8964425f69a9315f9f1694ba8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c22835eeaf09a49c67a75ea09812d0088ad32ca33100c40f8198c670a0634a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7d7bf2d6dfb73c1b2e416f09fd52a3f687212022bddeed5bce3c5102550f2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad89b8dbf62429679bb7bd015a50e144ac1b90416260bcd461070adc00e15a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9258cd784898bb0088827723cab95b0b88adee8427b504968959b072d734193"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5a0c3c96264043c57f19ae5f6af7604a09a8f1731abef0b19c567b76cc4da1"
    sha256 cellar: :any_skip_relocation, monterey:       "f0edbfe64e1bb657d46f133353ad2430d5494341f32acd60accce7515fdbe87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "389d4d3e07fab0bd5dfe217df57ff6232da2bef374edff8b830d73d20d60d1b0"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "version/version.go", /var Version string = "[\d.]+"/, "var Version string = \"#{version}\""

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
