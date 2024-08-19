class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.3.6",
      revision: "4c4fe3f87fe1858b35bd0d41e093a0039ec4cee4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e116dfe79209fcef1bb48212aaeaf20a3e5ec50120ec27e1226175b67472312"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8b83b9acff2262dda618d6865b1a3c6b5e679ae4e353070973cec1d7564f83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e51f71b6a9c7c1968fbaf5f25f07e19d4677c64867d2f05d88bfec05e3542b"
    sha256 cellar: :any_skip_relocation, sonoma:         "94bcae532e79bce1346c9d638741cd96755796eaab5c30dbb07fbed34fd3d56b"
    sha256 cellar: :any_skip_relocation, ventura:        "39b383262b248bee88bd21d58abd81950aad12487ffe7fb2fff8d10bdefc28f4"
    sha256 cellar: :any_skip_relocation, monterey:       "33e3dc9630eecd39d69ba83048f4adcacbd71b041d0e5b5e9c14d4d18898dcaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52de9ae1b47741402d07abb1f04007952a1142be651776a28fea1435c3ef4875"
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

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
