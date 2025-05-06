class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.6.8",
      revision: "6a74bba7e7e19bf5f5aeacb039a1537afa3522a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5874a51f1c732cc66916cbcafce771bbbe2e44fbf427696563ae7efc5cd3a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3d2df907c47b93d4ca3faaab05138d1faf50946aa983772869aac6e5600dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2313adcf00453854fdf0df05c010e4feb8dc17ce9940787ca73813945c2b7293"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b403e7d6c70f9245160a85f78233c88737a8787e45717be6f61481914d29991"
    sha256 cellar: :any_skip_relocation, ventura:       "38a282103ae3d30dd55d743545a2a67df7b2f513163defdc73efdc34bca0b1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5ceebf1abf88f8d666ab9bc02d2b1d7bbed29d1dcff89687e4ec01a097fa7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3cb540f941b73237c839989ae8335d63e791aefbac7d18e80a2f48634d20e6"
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
