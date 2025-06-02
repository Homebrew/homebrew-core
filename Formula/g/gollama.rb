class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "70fc868a0e0d2a81dc4be2c8d802f956617654fbab7bacbb9afbf9162d0e847b"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939621719dc437392ef168588c1550bf3e0d0dd714989c75bdaf59416b67f1da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e21fc58fa21ecb8dd3f14921bf8ace16f506e4c67c9364fdecddeeda51e7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa138db2c17be7b15c9e867cbd48a1d3d58efeabb529428fd74b2b4b61885c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af8c5f2eab49e6415fbbfcd582f1b7198b56023b9258187c0619b9e98fd9051"
    sha256 cellar: :any_skip_relocation, ventura:       "b338e549a94f5451e0b5d50d4276f291cd510b9f03fe97cbf06c67ee1d815176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1861d3394fbd9a652496d1df4be51177ab3274286205230e44963ee3b519c1fa"
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
