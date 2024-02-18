class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.25",
      revision: "42e77e2a699ab0eb2f27fe8cde6f4b7f6eef225a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a823c3f2bacfc81d4db5a2857aff8be28b8952b3939fcd97fd10af42b636fde2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30f6a34651593fa20511286efcb3d93bdc23a99ad0fb957463a7fb8f959237ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be18fb9eb72aff0da8fdeb407c32bc4e9eaa34aad99469a7861f8dec65f1b720"
    sha256 cellar: :any_skip_relocation, sonoma:         "003b02169dc413f8028f0b883ed60f95a0dad839642d260713b1c6481ecb8731"
    sha256 cellar: :any_skip_relocation, ventura:        "c35fcd836ccbaf5b25dbd7f51c0ffab237ccb05b3143feac87ebab66eb1a8675"
    sha256 cellar: :any_skip_relocation, monterey:       "727f24825512a0b18fc4d5b736674e0e8f8cc5652f536e61cc3cb78b6de4c80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb979e4aab78c109f735a375ab131cc92e1cbb140b7e4cc7d45da14e96a3fc5b"
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
