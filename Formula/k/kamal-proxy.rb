class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "6da015a410d6cfae3e46b429b9efac17cbe6f89eae1415231dbb1a9f159d9352"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cb33be02a13850a0cfd0ef0b64c3f740ce076c82007970de17dc36f2d20f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cb33be02a13850a0cfd0ef0b64c3f740ce076c82007970de17dc36f2d20f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32cb33be02a13850a0cfd0ef0b64c3f740ce076c82007970de17dc36f2d20f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f206860e7a63fe69da20ca236702ea0063b4592680ec2f4d5e3166e5c063280"
    sha256 cellar: :any_skip_relocation, ventura:       "4f206860e7a63fe69da20ca236702ea0063b4592680ec2f4d5e3166e5c063280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af972c3481eb7258edc958e101b4454cbd6110e10684055893e159dbaa6e22e"
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
