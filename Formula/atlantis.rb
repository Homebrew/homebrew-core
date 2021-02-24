class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.16.1.tar.gz"
  sha256 "23828bba56e6ae372b35668ab7a1055ecdd37076391760801f4436f4c9a33680"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ba03abca37b8286e5362d347fbc8589c40181edb38f9b62b5ce792845c89231f"
    sha256 cellar: :any_skip_relocation, catalina: "b28d79960d9d5723f4839c8b41049862a7e399d19774c669e2d1b144d35076a9"
    sha256 cellar: :any_skip_relocation, mojave:   "97bd297603b845ba27b2d87a24ec2191b6b1ac419fd297ff480d51517ac65f6f"
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
