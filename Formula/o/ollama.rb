class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.29",
      revision: "e87c780ff97673d9f906980d68b4557032bc4618"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ad4759ed060640006cc51e7c8f3c532691abcafdbd228ea1075ca0c70ce23f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef8805b6824e6215f08ad3324390c1715e0751867da53389c81e9383cd8c4599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e53b2d37aee0cff7e3f2bdb81cc95ce904eede977e0d2b00b0b461ee8f685fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "21efc7e5a420ceb503c8d86c52eb4b8f1f89abb86f2b6af9d4bdb969ee013e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "f97f46f22c0bb411951139f7a10bdf5dfc31c84086451df856a6b7932a1e15b1"
    sha256 cellar: :any_skip_relocation, monterey:       "f53673461234ff6587cfa3e8172352cce0338748c2f1a18e332dba3cc98baf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1032962987ade43dbd244b544093a1b161082dd155b95ff3a873123d952193"
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
