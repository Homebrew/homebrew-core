class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "ba763c06fd22e3ea4d7aaa26d8aac206727d266943fc3b444ff3d841d2074406"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    manifest_sha256 "df822fd304ffa05ab89fc5ac6c6f06cefb757c4262cbd265f6627942b20b85ca"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63026d2b42f21e084f1091abbc818e6d5d995aa2068e71d9acf42cce21014849"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d79d7adaa53d99ac5431e58dd0ba36ef0fad8fe43d1743370ebc28063c89610"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5cf6badd70cf2b2c8d83aff9a196b91ec02587a5de63e3b3bf211234c3883cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d489e49cf4ae97a4d2cf1563f26cf4014d5762f1c8a86b5e6980d4642b70d3a"
    sha256 cellar: :any,                 x86_64_linux:      "25a95e5479021e2d405ca1e79c6affa61252693d7877f8d6c148c40d8005c7b7"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/kamal-proxy"
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
    assert_match "Starting kamal-proxy", output
  ensure
    Process.kill("HUP", pid)
  end
end
