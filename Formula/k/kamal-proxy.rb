class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ed75954d6b9aa119d6e3853600b92ab80d9da029b5ed506be07efa016c7646a1"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef37239b56025333a167704496ee426d55dafbf0d4b988f366ac97fd1e9b436f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f96df97d14d4168df4d077afbb5261c2073996788ec62aa5558bd8c8f1a854bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891d4f74eb3a1f8c6436fee0d2d77f5ce43d0d05f75f642cddb865cb3991d306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30e9ef8f836b80e26dec8e6429a8ad69364bc32290b9f6757eb311630e36b1d"
    sha256 cellar: :any,                 x86_64_linux:  "2baca77705c2a2503787bd0b4f1bc82422b1509e56cfa4f451661b7f34a1267e"
  end

  depends_on "go" => :build

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
