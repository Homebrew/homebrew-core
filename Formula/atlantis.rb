class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.14.0.tar.gz"
  sha256 "32e24f4d341be578137f74385c9c97dd10461d260e23c77ed84298c578ec39e6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7ffb292c19d036fe0d8768b2e7954d7d4b7b3511065bb1673db626c0fe06107" => :catalina
    sha256 "5e4c66b514ff450a0161a5e3792b4a1ba0498b29c4fcaf9422f246f454955030" => :mojave
    sha256 "b8d781f0ae4913a2a7b84ffc01c524528c536547bc219fd55a11b4db49ffe898" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
