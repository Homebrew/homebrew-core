class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.13.0.tar.gz"
  sha256 "7e06f1e4d9410611763f2a9da3d45ecba6921be77a8f5d1ebba722047cfa081f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c71acb4eaaa764b34c41449ea2ad0d8a4078daee94d96849d26316e01dba671" => :catalina
    sha256 "f0f4f37b72be4d8c0c66ed95cfb402f1c8693a11fcf9e470f88b0b2576b585a7" => :mojave
    sha256 "bee44196471c4ed1064b90daffbad24cbcb588bcada6013625e65fa7912005b1" => :high_sierra
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
