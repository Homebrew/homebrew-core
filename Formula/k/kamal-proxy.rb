class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "8bd93ab1d5b7c141f85c6a92842bf639d39616a8065e8a7f8cc5a75cd73fe74a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844290dc5569f97864f081af1f9ae9a23018f63adfff1a5b8ea55e1eefbc51e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844290dc5569f97864f081af1f9ae9a23018f63adfff1a5b8ea55e1eefbc51e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "844290dc5569f97864f081af1f9ae9a23018f63adfff1a5b8ea55e1eefbc51e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a166d749e7d70f894b66c62e8c6af0720f1af5ae35e7bb9c96ec3e4db79382ab"
    sha256 cellar: :any_skip_relocation, ventura:       "a166d749e7d70f894b66c62e8c6af0720f1af5ae35e7bb9c96ec3e4db79382ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08edbba451dc4346e0d45027b4e60aa07051103b946466be2336b33f285cf98"
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
