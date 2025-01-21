class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "8af4875c8a6323becb4b317039dfaad2b4a7465ada1649fcd24ade1e53863c5a"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "999468492f009d44a843e187a547a792e09b23c68fc080f028007e94e961fde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba9707feac7add3ce6a43affaa9508e97dd67adf9f1d7a843630305208d983a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf0894187d886666af8b1e9157be743d641e31a7b9cf9d21bfece8755dc5eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bd5d0e4468aad9ad5ce9828d9eaa986bb40e85f101a09e32b87d16d5289208a"
    sha256 cellar: :any_skip_relocation, ventura:       "96619d40d0d6a7a79cbc3c7bcae98ec26d1b1afecd4db9fbcf4d18a43a997cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ba4e03aeb982d62bd8424a924c0c96dede2856f7f8881d0c93ab79f25afe76"
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
