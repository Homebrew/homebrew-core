class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.37.3.tar.gz"
  sha256 "563465fcdbbbd729c295950497b71fc3e9413bc5f454bd1f1a239774ccd9c4c2"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a68a44ea48b321dd4cee5cd5e23730452c0d5098ac39a71c88b9e097fc57d6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e633a3064717231a73953748639361c901d6c4f1a42d55190e88def49a47ab58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c63041b6d9a2d4c1756269d151933d4a94f547d681256f3eac5ff90e54c8e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f6cb365b81aa718cdba94c5d76dd24978b4bef92fe5d0463c5e92f649d0597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36013c4b4cc45d95c45d5f4b97e8a2177d29e21ce6635802e9d5afb6d889a5b7"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
