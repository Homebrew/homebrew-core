class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.27.13.tar.gz"
  sha256 "937d9a0e9b0e6c21059d1f344e795d64559be46c8a14d4fcf2c76d498ce69fed"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cd327c65460f84d48463043d7f8057fc001194a494e1d0f971282bd13a570a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312a29a1d6aa3cca11b98c955229e4434f99c695f7b1e9fa53e2285b1ec6abba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a6cf85fda0a9d734931f62c88a560d28e38a7bbf396ab5e4fb53b31eb59490"
    sha256 cellar: :any_skip_relocation, sonoma:        "c473a40bc2e653f3273b3a00e6c78522d7c4801de25c8063fd3694009ce6a234"
    sha256 cellar: :any_skip_relocation, ventura:       "d2e4a850d2e211efe5bc9fa47fd7a3d1b2396c01d66980fe111c16df4e15e89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4f7a034d98f462154588a15ea855cf5797feb697cd0cd5fa2fddcea71ab39a"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
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
