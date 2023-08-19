class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "c97a0e8d26cca73e5a75f22f90c300733bfeddc3f11ae3280e76d0c10ef14ccc"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb4ad3e13a329c686db9d36f59bdc200ec520a6d96f1961a1860341a67a20748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532803afdb9f3f74b9e02d33d01f523aa3021e17dadc6ee46daea57d5a425c8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a6e6cad9a5e350aea3138b9e7d3fb2c82aa0ca6c710007dfae0306ebf9b9bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "827a41ec68619787948439aeb8cbec215578060f5c17579f664a4aca45c4f195"
    sha256 cellar: :any_skip_relocation, monterey:       "c43da513bc3d09057db226c3a6266e3b229851786aa3f6caae2caebb1779b31f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea2823a7233b8bd0d3e7f0f024868394233be5b5d0fedaa4313b416eeb359609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720701af7f81c07a54ae017b0a86af4b6fb9cd2832b0da8b119cd81dceca44ee"
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
