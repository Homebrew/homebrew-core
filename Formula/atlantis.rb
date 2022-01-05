class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.1.tar.gz"
  sha256 "4fefe422c769a5d31d9c280b447b4f370308ceee23ba579f2d43bffd72853c76"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f0937e5e295cb793d8337a21c8894cfcdcb151d2debdf735a05aa6aca36c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc7a110eafbb0ed7b6fb9a8010f4374e16c12bc746d607f2a1851a2d732e9409"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb3fe66ea17f288c5132eba5fa5666e4cf58e3b837507bc2425108edde8ab41"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c9fb3855af2de4b159d6af284073f16eb075da23cc32472109599bff5ce3eef"
    sha256 cellar: :any_skip_relocation, catalina:       "ece13eb7aeec5e28fa8f9c5d345f5977491a0a86bf786c60fb3b294008216366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f4e78c2657a8041cf538a52e0cf3d111959f1b1121fa3988c1052d9a518619"
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
