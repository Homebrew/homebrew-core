class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.3.tar.gz"
  sha256 "30a9d957ea5058410fbbc190056df86ecd56223a763b043a54cf521caf029618"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9ed2da0a6cdc0bab06abee67a582a681e3faa2592d9dabbf68d0d20b155f5ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "918a60de54e4d0a5439ee72d60e6a320b9cef060df6a3b9a862939944908e84c"
    sha256 cellar: :any_skip_relocation, catalina:      "365e3d3c5703deb1d539ce11f27f4b20bbedf72eac7ec09d801dc843533e5cd6"
    sha256 cellar: :any_skip_relocation, mojave:        "4cd407acc6a2177b83902c0462a4e080084d72b2259c87a6e1493f73dc499541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277c7d9c6088432c1ffa541018e071ba7a944e04f8e154e11f660d9c087eee77"
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
