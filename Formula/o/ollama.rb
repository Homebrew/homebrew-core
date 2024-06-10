class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.42",
      revision: "385a32ecb5b2987f9cd7decaf0052f0a316ac6f6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a63ea092d6238ba68103b598f44f3c89cbd7f4d3b8f207bfa163159117f9d0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d4c5a5e4ddfbf10da67abbc7efc5652df9445d96c1f0f633c61008c9bf80a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef085f3a1ae28f7859b622d6b8b55ae377a78a2edf392c12e46c7168e5c8e64"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b1ad2ce81f982eba2cc218d33f70c5ecf14dd4d55f150c0b72d01c28f7f56c0"
    sha256 cellar: :any_skip_relocation, ventura:        "d36d244188961913863091404b776d1fe085a1e49bd14f6b7436e0251ff43639"
    sha256 cellar: :any_skip_relocation, monterey:       "79cd1b6cf92ba0ebe7f7544d0da112137ec5447a5c0d1c9204049b44817e815e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9dd51cc4e390501e18832484f4ff6ccf353933ee39e66191b5f67bf742dcc18"
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
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
