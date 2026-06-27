class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "4f746092830783f3bdf66560044e89773418403903ff786a01777b98ebd7cb0e"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ded093c00bb5e362912c6f68d00a03f4e6964b49e0c3caa7f7eed2501855b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c69192e8977cf4f84bcd2b0ad912ca942a1b2a09df7d3f81999c70d6084b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb6b831b90e01cb423d8a3713d649f72b1f677954de2e931fe03a6981deaeee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2458d08c73df44ac997f4fb7a47c44fa1e9f6ed63100ce51aeee9d633aa53e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a9191466f369aaec7af7cb900d10d0cf1fd4bd02c4bfbcc89edab73f15c817"
    sha256 cellar: :any,                 x86_64_linux:  "b4bee7c87ed40a9fee54ce0441b2cb8178c8a3968da2ca71010b9753d5f728a2"
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

    pid = spawn formula_opt_bin("ollama")/"ollama", "serve"
    begin
      sleep 3
      output = shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
      assert_match "No matching models found.", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
