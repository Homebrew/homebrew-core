class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.47",
      revision: "123a722a6f541e300bc8e34297ac378ebe23f527"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b01a8fa0aeebbb945a9baffb8d7d3ba759346ca3d0a3b00429fa1531f0f12dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad5ff3539957ec2fc8fd056d8cda14ebd00d2c503d98e97c23e13f690dd9f487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b218759ca25eddb6d303ad2ae01a42032d27391e8f6a16a2a92e3bcbb006ad8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de0e4ea23b6c9d13ce5f4dda0c4ff3ea1e894508255ca5237c0ebd37e7e57e7"
    sha256 cellar: :any_skip_relocation, ventura:        "833262c7233d91159504fe3c843a795207b8c4fb110a58b4dd87a76ef755aa0d"
    sha256 cellar: :any_skip_relocation, monterey:       "92e447ae1faeab2ec5255b72abca45e9db6ec45e82a7fd71625fcac952327468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae442381c0a0d87f9f2411ec7683365b1026b40481c9b42a3324b0e0fbc20e3"
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
