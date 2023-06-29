class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.24.3.tar.gz"
  sha256 "8f1a00ec8c00ba1751d32a1dba990fb2f4af19456a572c8a77ff452e3c883787"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06814571beab52b6cf99d09b60d13960453261e9fb17c320e260cd47f23ca780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06814571beab52b6cf99d09b60d13960453261e9fb17c320e260cd47f23ca780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06814571beab52b6cf99d09b60d13960453261e9fb17c320e260cd47f23ca780"
    sha256 cellar: :any_skip_relocation, ventura:        "c3dd4e951217e0c2a51646826f4c8287765598ff3b940a7220c78f76e631e5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c3dd4e951217e0c2a51646826f4c8287765598ff3b940a7220c78f76e631e5e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3dd4e951217e0c2a51646826f4c8287765598ff3b940a7220c78f76e631e5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c186c94503f076cbcafa7c3fca829b51345139cc9b656d4d9420778220bfd8"
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
