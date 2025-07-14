class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "a83413be3042287ac72a8241a483edf78b6b4318a1a0dc4fa2cb0c2687b290ee"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3fb143ed13da91a2b8579dfa167719c0835617ef28399ecbae45db94f12ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d077ff90f27b5fec9a5b87e8e6f680bd5cad640529bce35a304dc9057bedbdf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5c4041ca1372af07c43cf80c8aeae840721f1eec2b93dcd382c36d3c00b13fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaeb37f4c761f7d86f9981cdd49d987791e65a66123343a6e5c290a2c654298e"
    sha256 cellar: :any_skip_relocation, ventura:       "3e31d11b7c37bd8b5cc4e1c2e2e1106773a10cd7b188cb5ddc02f94107e03e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7505c632cbd5a508f5fbaa2e8fba89749632d42315675a7f884cec309eb4a662"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output(bin/"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin/"gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
