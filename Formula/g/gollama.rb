class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "a2b57d378d8a2741e7b6eaa762b14e6d263a9a7c3edc171be32482a491516441"
  license "MIT"
  revision 1
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3562a5b2c207b91fed7c70227fd3a8deba55acb8626fbb4987914da29951e397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df66b75b3b1af9c9bf0cc26d4a6bf5483b7f1d8e902d5b311d6e7281444e0600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "772ccede9f6d9cc7e382c90d91d79db30b3fe41078e4afd144de12800475285e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1781a0cf8cc7a82f76389e2159e36221dcd95d68c99f2931b6f95360ebd52f75"
    sha256 cellar: :any_skip_relocation, ventura:       "e43eda5ee12ee5ebff61b3b15f707fbf11dcb17494db53214738ba2431e1c458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b5076b16180d553cff9f3e238f736fabe780b2f5ad4a9118240d721f1d0b3d"
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
