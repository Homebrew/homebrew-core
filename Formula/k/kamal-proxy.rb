class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "cb53b4f73ec9fd8ab6fa888e4994223fa09a6095b8dd40d9ada58815c991d658"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e3e81860a5da7b0c9fdc43487edea33cf65862782a38b4609e479846318b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e3e81860a5da7b0c9fdc43487edea33cf65862782a38b4609e479846318b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17e3e81860a5da7b0c9fdc43487edea33cf65862782a38b4609e479846318b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "937706557e2c0aa647a47ec99c1437f720aeba55312a45e7bc6e5c4878391d64"
    sha256 cellar: :any_skip_relocation, ventura:       "937706557e2c0aa647a47ec99c1437f720aeba55312a45e7bc6e5c4878391d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b4b055aea27e702b6e63a8a71c80b241f1e6eb06c97fd5e9f1e0c6c5d13540"
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
