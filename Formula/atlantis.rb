class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.0.tar.gz"
  sha256 "5403c6518e4c2c9d871bc44979a21d5e8308c48bfd83ea9ff873dc773e87401d"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7056af17c59125a494cd196d01db1ffa173e15bb16100145805da62f909a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b691d6719c816e6291a4c30bd395c2e164afa53b87671ed1483f3bc2ebce5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8681b29660721ab54d77ab62136bcf566cfc8e30e8b8ae2d4ebbf0e49873d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4071364b44de5a54742f3ab6cbe7692fdac077c9812c14f2159b425dc5dc0447"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba3d89c771d03a5bf3a8cb26251253e03525b9e59af0d4b9f82e42b9c94523b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c642be0e72182788af20aca6d6bf7ef43042fcc359b24fad72083332b5d271"
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
