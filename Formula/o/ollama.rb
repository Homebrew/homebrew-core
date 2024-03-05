class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.28",
      revision: "3b4bab3dc55c615a14b1ae74ea64815d3891b5b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07eb38095055b78731efe0ea74177233453130fd0e9604180579c1a8b82d1c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "834a6a97f7cb548e9f2f9c2cb2599ded45a7b75520ccf6116108cd2b4f470af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd2aed7d866fc9fe5beed2d748be9afd80430edb6bf190226c1b76e1fa0307f"
    sha256 cellar: :any_skip_relocation, sonoma:         "446ed06e535912b0321b1c6f65ef41654b3a2f42c79ecf3e732f903c85aeb1ac"
    sha256 cellar: :any_skip_relocation, ventura:        "7d11ac7b66751e462ddafefa10e803d90912f473b774aefca89f64f4f9d75fce"
    sha256 cellar: :any_skip_relocation, monterey:       "c14e27f290e23a1acd6c311d7a451167ab3d064e0d2178d3b6d62deb488cc14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a352ffe9b06a6628a369693482675c5235ce22e1ae9e7f3ab8aa2df803c4bc97"
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
