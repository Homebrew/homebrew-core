class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.3.tar.gz"
  sha256 "979f4fbc7d79b7bc937c86aba2cc288e74b082bbac20937382e3a5a2fc843d40"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d69102a25f99a1a4cc8b27bb9e0d77f9d2e3a094cfe714baf3397a4f82a08a96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a4d9fc4edb2246bb6cf72676be0ba160519116ebea48fea960e33ed015fc052"
    sha256 cellar: :any_skip_relocation, monterey:       "e534e3f84924d466e9d7ee6a58c568a9bb0dcccd84a892caaef53524d9faf282"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bb7babe7e826fa3ab3f4f4af3ae35e8f2dac3435f3219f8c1fe586e19ff5dac"
    sha256 cellar: :any_skip_relocation, catalina:       "317e02234a29fa9a2afcf1cef4153f1680d449a4d50ce4f878ae74993a18da2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58630e152bfd987ef154c09add2a34e528a1c6507936b39406c152a23422a4ce"
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
