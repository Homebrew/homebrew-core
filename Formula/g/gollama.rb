class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.28.11.tar.gz"
  sha256 "41d3d4441676a9bb96fdaa869900b96d8cdded83b11dec117da432756819f1de"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a44df7275f095ddda8786894264ca65adf1ce1c4daac2cc221c7bdec192558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d5a60aa6dc4e125ec57743af48145aa784e8884564ffddf936ddf885027f38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c19fd80e7fac5e762d2dce720d6ca9af477615377096afbfc6c941c5886b987"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c8c649dc56d12ad758bd94a1141a308da4d3e3494ebf2e8388d26b170384e82"
    sha256 cellar: :any_skip_relocation, ventura:       "4bfaf42d5d3b29828634c8abb2e1767482fb0204960d759c803b7d9057599747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a0ce16cef193dd8931a7b06bdb3b5b213fd884f1b75d75339d4872e577378c"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
