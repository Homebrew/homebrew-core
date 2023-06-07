class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.24.2.tar.gz"
  sha256 "901dee26c70ee98ffcf2fd75d28865787b126bb2b5c3fc27d46f71340b8c36dd"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f6c538c1761ca6c6dc37f16156a0f72c5bb25779fdbde33d572aa4b5c771e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10f6c538c1761ca6c6dc37f16156a0f72c5bb25779fdbde33d572aa4b5c771e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f6c538c1761ca6c6dc37f16156a0f72c5bb25779fdbde33d572aa4b5c771e9"
    sha256 cellar: :any_skip_relocation, ventura:        "203155be9dce3b78ea46947d7f3ac76d7d8f86883deb8a7dbd7c2b07dfe2c3e7"
    sha256 cellar: :any_skip_relocation, monterey:       "203155be9dce3b78ea46947d7f3ac76d7d8f86883deb8a7dbd7c2b07dfe2c3e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "203155be9dce3b78ea46947d7f3ac76d7d8f86883deb8a7dbd7c2b07dfe2c3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75db0b6d1d8ae831982d7a639d9908f989f98792d0c6b1c1f2123c6d95cc174e"
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
