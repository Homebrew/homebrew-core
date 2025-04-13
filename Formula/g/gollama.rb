class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "2203c329d4fc47a5cabd16c358d441739a071937ceef07c82f19faf0eaf3a790"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61da202b10347ee125cb92fa0e21d66485d1c368dec90260194918bd38ff52d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2feed35b888877d0cf882d20533bef223ab9df60cd71150a8811a9bb22c8b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f66fcc50dd657762922c08378e7656ea883d3bddf73d8a7ba24b9a0b74b6a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b28945563d96c152c9813dafba98d306669aa506a0d688e98eb9d10df00820"
    sha256 cellar: :any_skip_relocation, ventura:       "224dcff0f6cb455c1e563fc2ed9804834ddb9e5b1b4da9d14d21c269c2d560f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c80a5d2f46a457d9b328f76f9bcc94eb6791d3aec34013943e56dad922a060f"
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
