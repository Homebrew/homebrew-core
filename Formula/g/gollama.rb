class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.28.13.tar.gz"
  sha256 "01becc51c33587d1862c257f14d9dbf644d1c3df9b98b44d77e292221d94f4a5"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3864a566503ba14b511b764ddcf8256c82e1ad4cc2a5b969fc775b358d8208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b7e28cc6f16a0c24b6e61234e06a4ccb7d99de506fa266e35354b33b16824c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9c594fb4bef94f8c4d707f8087be47895bbf7007c8bea64873207e5ce205bc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70da50a6f8b15cce9618313a659b97ca337d9ddb30fc1be6ab0bb656eacfe69"
    sha256 cellar: :any_skip_relocation, ventura:       "45513c97126593db1c9a25dd2a45cd6c094435994a7cabf10e012cdc7c679597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a8099e463ca84c6b7fbda798f496fd734b0601e63304d33b9b58febfa78bd5"
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
