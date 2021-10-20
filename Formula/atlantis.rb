class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.4.tar.gz"
  sha256 "1556e4467f81e6d8cb28da6cd1ce530611b2f94f112e3a92bd818426a364a5c1"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34ccf2bcfb485af92d761922ac72fc54514cb521eaa40e1a68748a83a0d9d653"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2be21a4ccc836e5ae969eb7fb7747dfc9c44bfa30eb7800be804e5ec08ec043"
    sha256 cellar: :any_skip_relocation, catalina:      "5da4357cf27e81f814edb89b957ffb274bd2fbe9415d420b49a7bb5c2390270a"
    sha256 cellar: :any_skip_relocation, mojave:        "ee4f266cbe5de9c4dc285c9bbe28e832bb68a494cfd55a042d6d599616968759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d211f5eb8ff4c46ce0aa6be40de32b5e5b560c782bc999183a21be4e14234bb5"
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
