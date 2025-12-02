class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.37.5.tar.gz"
  sha256 "d64827e4267740d3cf0db4a5fd2166478f6ddb97b42e2df3a5fb284ed19ffa27"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8643b24753cb0ab504c9c699b20bea0a0d42f45aceb163d7d504929fbf0566f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a02a0a823c740f626fdc188b4b93834f67e496233e82bdb95e72028df691de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2626927f13a76f08fa6faa6a6d57976b343fe7347db6782920f75b34c15669a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b6629190f84119ba1047ebeade3c01716764620ed1688d8ce2fe498ac37565d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "975bad798da56e6a7f1eddf011ee576a8e1b282674c024340c8cf5598bb3217e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2433b22053829db326a83f7c72aab05c33599f3b29ac88175c8d3e9a49b333a2"
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
