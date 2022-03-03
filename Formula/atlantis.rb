class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.5.tar.gz"
  sha256 "d6fba591825a33e3c2baa1c00211641fb293233a9fbaced541d7ebbfb05dbc4a"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450c1bda2869b53b83d572efcbaec4fdab2bb26e5067688dea59fe1c162ef6b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5630f85bcc3ed50e8aff464d5e700e43eff2455cadb424b4164d4baf2221180"
    sha256 cellar: :any_skip_relocation, monterey:       "ddd57903ffe661350c8c0ec2b1cfc60dabb25d3c976ffb2bf27cabe47e73dbb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b3fe55c6f0414db7e18c7a162f0648a734866400f9f3e277e5d2646f0459de"
    sha256 cellar: :any_skip_relocation, catalina:       "3c41444f96a2368edddba06fac097e536a2211dcd78caaad5e6c5b270e8489f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1901b04390a88b213311bcc0b2099ebedbf413ef00e5b1d3a794c3b37ba0b444"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
