class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.14.2",
      revision: "55d0b6e8b9498a621565c93625b7e29c96812f21"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ac78b51e288a1a16a9e4b39a5d85b1d27af811cc55d0030192551ebc98c54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dcc79ce344538ae762ecb2ce45de12a39cb525a1ff548c868c39609824affe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da4c79145e4c869655ff5b185cb6cc27fe7a3d0c70011c436be2bdcbffee356"
    sha256 cellar: :any_skip_relocation, sonoma:        "de8825a1484d8e4d69ef9e4fef5d6e2c9c757250a0fc573211c50d312c55dbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc469ee34aefa1af12c97c8615fb35f07a9a39eb922b521052dfc84addd9d1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bedcebb9c979112b11790c74dd5aa3d946b7db9a87814c8b1b21d8663bb7bf5"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
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
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
