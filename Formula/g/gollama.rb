class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "931fe8d7b964d141773af1e78e9c0cf24b96a5d246d7dbcfd32c92c88c4dd3b3"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4510da3411093eefa5286e684d35512babadcfe46030506fc5febc87066ce775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c678353e598dea961a66cca3ae3dc9b08e957ab71af8434677b7755e7cf2f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20202853e67d731ac6e4340dfd7d05a6662cc15476f3fe75a093a8b52ea66d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1d068338bcc3206b85864b0cb7d43d432f7dc43324b50bff93c48a3b592a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5a68b162d1111c17773d6ac1e7c6a433a48815d79e7ddc3052dc2b9d822c19"
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
