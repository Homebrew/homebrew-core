class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.5.3",
      revision: "87f0a49fe6b0db7de0d6fa76e5d2a27963c10ca7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900abc11a64d19247f3a8286d3dbfef58c7df0ce23216352f6b706f56844a78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45c84263128b4d13871a1e0707738a0c043d089d892ab3f89c9b215ca20cd83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45cab8ca7e378c265de812c0c74c9ffb3b5f1999a6bc6b61a2f254f9a80fb821"
    sha256 cellar: :any_skip_relocation, sonoma:        "04be389648b1ad4157af7dea05fe9deaf12879e3c686f22c24752f3f2542e447"
    sha256 cellar: :any_skip_relocation, ventura:       "cf1ca3d22fab5ccccb650d0715ae5c73825e777030aeb9ae2373bc24c13aba9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d26693c4d741314d890eb56c61ec28d7d9576d65653b4d53332874f3589cc90c"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix to makefile path, should be checked in next release
    # https://github.com/ollama/ollama/blob/89d5e2f2fd17e03fd7cd5cb2d8f7f27b82e453d7/llama/llama.go#L3
    inreplace "llama/llama.go", "//go:generate make -j", "//go:generate make -C ../ -j"

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
