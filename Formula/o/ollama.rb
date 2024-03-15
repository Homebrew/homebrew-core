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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00599d0091627cc8baed988c6b6705eb2bc7b8bac366430acbf279d1a4c084e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3351f8ba817c9309840bc3a5cfc467b188784918785b21c48f1f156cd74c76b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fc984fd167de16c34fa2e6ccd2de4ded661e575e7322e3269b909f844fdec5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e56b668ed38ebd7a97409f249afe73cd1d1a2c411845590dc6b0ebdeecfa1a2"
    sha256 cellar: :any_skip_relocation, ventura:        "8fc832cdee937cd504ed2e0e25ed01082a7ac05f6a2bcb92daa907d288c7d11a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7f43cb0821068a9c37152a506cbe091360ce6acda0d36fd36aa6679fcf8e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1f59cdd000335e4036220937caf3869872a8b6638740a1561ccbaea6bad717d"
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
