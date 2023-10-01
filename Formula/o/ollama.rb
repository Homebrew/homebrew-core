class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.0.21",
      revision: "01c44d687eca23bf101c9617c6db26683c2c8c9e"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a9c9ca85adfef534f31e8de18b0b7c55bb8daef03fb124d70792b8fddbb4ee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6cc4807d04def80fc5c0f9d6fa9739f67d7a456ff7e5cbd4c33ccdc2f2fc92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8c37262159471615e35441467ceb8451623161a5b4366c903322db22943cdc5"
    sha256 cellar: :any_skip_relocation, ventura:        "f464b09016794bc2aec63477088e0874812d457ca3ec64529de69dca2fcfe6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "215eb79e173596c3869db0ac3abfbf9111202d8a5e4e829529cdb3a9f8ea1189"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1292973d6ca3ea0e9a516cb0f93722ee7b2b3f7b3d317a6feb3a4a17030f054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce34f446b04d659f0db6b0d1727835f3ff3dff3a91036a0fc2e62c3f3c7710cc"
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
