class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.44",
      revision: "c39761c5525132d96e1da0956a9aa39e87b54114"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59b3c5ad860eb19a117dab7e745e8f6caf10afb26450d0e479cd6666a19e4c88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67f021d256d0df78714252856e1bd96a32fc1cf3e787c6d583a067de0c7bba79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e607c1492242b198a9238c89bb456894ab1b7fd7c579e707b93a555fab0316"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfcf32a51257697331e6edac3ae2ae86706fe447cd67fd78c437bf63447ee29a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8ad2dea67f1a75bdbc17149f0685046d9496d63c033d2007d2e02b6fa61aff"
    sha256 cellar: :any_skip_relocation, monterey:       "c7451294d51d644fb9772601331ab835c18a14db060d7872ce3373eed6ba7605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477138a3023713e0d77f6969713ee3ead5c34de43dd112bf706102a7328fa55c"
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
