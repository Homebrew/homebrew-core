class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.12.0.tar.gz"
  sha256 "df7c17fef4b37347fc22e1c5bf3d2b29ad1b219e70b6bff111e38d8ee01102e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe8ad0c5f2bc948ea025f68af0969e7880b00b7223f76744fc2007251137ef4d" => :catalina
    sha256 "efb339eba2e9d7dd3088ea781498491df10472971027b0414014aab687f716ac" => :mojave
    sha256 "49f3c99cc8e528d3d31e6dae17c47ef54ebc9ab0cf32119d2b44fae201327891" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = 4141
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP\/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
