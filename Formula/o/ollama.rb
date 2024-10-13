class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.3.13",
      revision: "7fe3902552f762e6cc4f78eb83b2a60c6a6e61d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0509f7907668fba7d03027c26a01e714dc8a6bf40cf4b41f9e334ee3986c6a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4940404aabb083471aa8b3e814556198b50394962c7cdef96f2f639544fc27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2358d6e3cb7dd786d04b15b042ba591165b85048fdd0c7eb33789e9950c57393"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f3a812db14bb5062f7af11973ccb464954c5ccb50bb474ffe73da26bbf8507"
    sha256 cellar: :any_skip_relocation, ventura:       "7b053e61daae822e148c48a65e9ca5737fefd03554d394d9876d4845ae81d7d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305909b435c2bb5c3afc427a225493127c36d4cc902f246df5f2a0b7ba852899"
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
