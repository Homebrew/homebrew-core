class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.16.1.tar.gz"
  sha256 "23828bba56e6ae372b35668ab7a1055ecdd37076391760801f4436f4c9a33680"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1b80f8b3397702e8a1c0d80f58874e77175ddbb3999b82fffd3a0be52b339ca4"
    sha256 cellar: :any_skip_relocation, catalina: "a20268869c1a55294b841c74663ceeadbd0434b6f6895a78c08f5e64da613130"
    sha256 cellar: :any_skip_relocation, mojave:   "105ae4b23881eeb51206fed19de86cb610ed4b35d0786d82e25aac365d7da2f6"
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
