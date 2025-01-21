class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.5.7",
      revision: "a420a453b4783841e3e79c248ef0fe9548df6914"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe8dbfeeb5284879408737c5615b91c8d08169536fd57742a987589ba44217d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd37facc87ba11d7bcd58f814b8e22f47dddf852b74d95d804f539274d8770a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57a1ed69fe3c1633933f67f4a91c20cd1c21466e8be8580477507749bfb84d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4390fe3dc7a039b1f86303935def4970bf0f5cd83bf0f53ec61ab80b63006be"
    sha256 cellar: :any_skip_relocation, ventura:       "b9eb13583578fbc6d39e8b4f573e47635c86b53833842354cc49f68376585a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8635b21f1431f65509182a516df6a87b41380237db1748718b472d677efcdb"
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
