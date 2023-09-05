class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "b3e749d27db645e30c4fba5da0a0601e928dc7cf2b6105b85728a18e21977344"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff0260cfddb16121b5d5629202eda13b755dd42ce2db37fa32159a7d86a0004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2388114998a753b6e8a7a35c0fa737cf501d6c5dbb2378fa333827df1dab20dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd084824a5ed069a8b17ae6890b305e6ab6fddad99253a971da083357a4a6b31"
    sha256 cellar: :any_skip_relocation, ventura:        "be21f8d5adfdba2405093ef8b071c9bb83037f75774304060bed476e183f4e28"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c63c7bc720d979652be4be9b6d5cc1490d69aeb9dc18ada7bc1d922532140b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e4ef2f1664198ca727bafdb28f44c0ad01310852b745678a3e87b61e4e5dc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b581ff90d73f5aa739bfa23fb3bb10f2911e85797bc378d9d5b0e5094bcc65"
  end

  depends_on "go" => :build

  def install
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
