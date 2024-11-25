class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5cbfc526812858384433499f790b3b3a1ae9e856de82142626bc65b46426318e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80d5418054e2e4aa0164183ab1b147646e54d5e9a8427c558d8fd2c20a0ecf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80d5418054e2e4aa0164183ab1b147646e54d5e9a8427c558d8fd2c20a0ecf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f80d5418054e2e4aa0164183ab1b147646e54d5e9a8427c558d8fd2c20a0ecf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76faa2ce718d8ebfc1b486898c4d8d76b488ef6d8fdc35636c054a2267fb695"
    sha256 cellar: :any_skip_relocation, ventura:       "a76faa2ce718d8ebfc1b486898c4d8d76b488ef6d8fdc35636c054a2267fb695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7158951b9ceeae61f501b5690734662e54dd568e4082d734f5e7b904dbcf3f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "No previous state to restore", output
    output = read.gets
    assert_match "Server started", output
    output = read.gets
    assert_match "user_agent\":\"HOMEBREW", output
  ensure
    Process.kill("HUP", pid)
  end
end
