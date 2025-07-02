class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.9.5",
      revision: "5d8c1735296299c3d81bb40f00038398dc729579"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d63d9c6037e43b6ef05275fb71315621b19c0a89e5e4f0cdcd4b714f52b73a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a1436f6b9d3255bc1593eacd517533c4919a36d8197c48c157960f4fcd22ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6c468c1be98ffe844de54d74ed80c52107ccdd2d4ab631aec5744bcef32de23"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b8e1842a36ea0b5c635ba87bcc9beec787f143ad6f726e5a0f1a70f028b002"
    sha256 cellar: :any_skip_relocation, ventura:       "397156f2b4f4738b1159d2cbf21ad67712bfa625ca1ad738f60b97b28847bacd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "081df6d55fd8d6ce6d1d0213c47e5b3be4a024a086e7ebc50bb2b32e089bfde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b174be94cd15029d9ff975a91b3ae18f3ea9284e808c125fea4c3151e1511abd"
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
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0",
                          OLLAMA_HOST:            "0.0.0.0"
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
