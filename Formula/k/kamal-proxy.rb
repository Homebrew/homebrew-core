class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "12d8a7ac96c71cbcb46b51b7d004f268a86cb45a44da010a1e524fb6ccd924a7"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "065b113b52d298d68c63fa2131575cea767060169046f75747e2b55d03c03ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ef131344c9f0f105992aec587df576bbf7c2413f0ac17993785b3efe1a0e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17166f0d9e23a46713cb7282fc3fb7b8b9ba77abf563760666bf89b8a30e10f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "060e0f6992d77247bb4daf6dcbaaeb0bc53768469c0d1fc1e67dc46b57f01cda"
    sha256 cellar: :any_skip_relocation, sonoma:        "14815fff3c55b5a86faf522f9f3d060ea30d059908f1ed0fb8c448866fa451ec"
    sha256 cellar: :any_skip_relocation, ventura:       "7dbb7ea2b7ed3dc7a06fedb1a563ecdb89d18f992d691a14a013398f343f4b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454e1da3b3fc882b1007faed2033dd3dc70e3aed4e5354891cb9ffc3c4bbb9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8e6876771e9d510a93a42ce58dfed4f1b017ca0895c0ae11016a34168a9feb"
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
