class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.15",
      revision: "d9e60f634bf420ef41fe5388b32cfda3ceb2c898"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80ed768e91d53f318a6d9a6bcc6acfa06afb81bbdd20ab36df6150ee924ef4dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "832907cbdd086133dc3d1a71cfd539f6a38be9df126d5312b866eedd0203ea78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e67251c3447f85fe0e654327cf8032b36540b4b0c97c8dac5a7201b9aaaa0f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d4bc0c59838950ac4324ad8caeda627b33427bfdb284dccf7dbfa1ccfdf7676"
    sha256 cellar: :any_skip_relocation, ventura:        "5a01b0689606dec2b464d20a52966a01affc9e5f63ec8c116a1fd4656b649f8d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a66f2630a197e36048073e0e21b1bb40b3104390185d8dbbc73ceba194b6848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4ee8a23c922dd7b85b07cef09679a2728e963f6f12d725ab2d4a55aa023b93"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
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
