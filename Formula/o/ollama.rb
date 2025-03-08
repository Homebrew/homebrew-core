class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.5.13",
      revision: "7a01ad76143973199bd6965c13476d2d04f10f75"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a63d2f2701357e7b4621703431e5ddb4be35c73e1938f3f68dce71d929e533a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3844b14b5ebf8bb2b9e183e69ccd365982602ddf46686c23d202524f5b770e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c45df5413641dc7fe24479a4e006dd9d4847e511e4aef85da24b8965f7a3e88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4d539e4c45b2504628e93a0b6e96cf6dd93809180f11d726e9c92f655a8573"
    sha256 cellar: :any_skip_relocation, ventura:       "4a05a89cf3564a3a6b7052aaded7120f58259cfba68f22a4dbf1a828cc185011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292b1d97feab8dc5c300bfb61e88cb06b6be8fada65e865631c71524192f32fe"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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
