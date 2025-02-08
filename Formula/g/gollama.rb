class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.28.13.tar.gz"
  sha256 "01becc51c33587d1862c257f14d9dbf644d1c3df9b98b44d77e292221d94f4a5"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f44969d125da9a3a2226fbd14933a415a5de133a31e04ac2e474a91f9372a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b562e97ea97404a9b6baf637f6793aa1df394654bd2d2fdf9a7ebcc4f2e6825"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93d24494368eda59c5209ce67ce7f59e9e111ba96113ce25475f0e91d5460c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9fbcc3a718b41908865dbe9e629bce6cf9036e723fae4f2dd29ba694c11889d"
    sha256 cellar: :any_skip_relocation, ventura:       "663647737042187d1ff3a08fb6b3d9401edaa393b5efbf0a05e018047f0a30ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea5c63eae349518d913113e4a0082ad3151fd9b58f070a10d1824edc3379dea"
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
