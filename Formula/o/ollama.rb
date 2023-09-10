class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.0.18",
      revision: "83c6be1666e8ccf9055e8b7813064644f0a1ad69"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0da28e219fef144292a2cc061277762ca1255e7be0405410ef2a28380743a7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a928fef0f7594d0763a303628ebbb9f88f59f3dc52b53470bb9e73d64cc53780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3580ca0cc31b6156839cac8b871488d91c58e620d54f0594f3f0c4a51813821f"
    sha256 cellar: :any_skip_relocation, ventura:        "417663d7ce22bd02ea3602a1af508fa4bf88ca6d0f8a3d62e1cab536689b0348"
    sha256 cellar: :any_skip_relocation, monterey:       "1785c324ef2915643006b370204675d8eeeb039db16013bb18a0ddac20f36cf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a488f1f65fb221aa6dadbf4c56087f7e52331c28f1b6eb26640685a5e5e7125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3810d198f5045d471315b8c7732d559314f91f52e79b77d5a4c9c6fb9f8a6c0a"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
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
    ENV["OLLAMA_HOST"] = "localhost"
    ENV["OLLAMA_PORT"] = port.to_s

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
