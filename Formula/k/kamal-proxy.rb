class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a87241da22ef4d4575211cd716105f16ad46b0742f2088a208647aedd7780382"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "815c89c303ec46f9a5e3938032a0614496327b6b88119a1531a20768ca604766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815c89c303ec46f9a5e3938032a0614496327b6b88119a1531a20768ca604766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "815c89c303ec46f9a5e3938032a0614496327b6b88119a1531a20768ca604766"
    sha256 cellar: :any_skip_relocation, sonoma:        "5953374362b6e69e7ad2533e6f0f0048146128703436fc43db2844973979de05"
    sha256 cellar: :any_skip_relocation, ventura:       "5953374362b6e69e7ad2533e6f0f0048146128703436fc43db2844973979de05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f01108b162b00b98b82cf4bf2d43e79752c6e194acf0d3836a4783142c52c17"
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
