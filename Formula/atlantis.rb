class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.2.tar.gz"
  sha256 "5c0da4efc288a2cd3f0456619e3048922542a421798ebb834b8800fc4dcf124c"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09eebaa12ee2741b1e5ebba4f1f41b929fae1b1fef97b2ef104c7bfb50c1b38e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7632380740cda545a5dc2ab606a3beed71bec4b28f8ba7f5e350ffd25e971cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e5fe6ebf3ce40571308fd332c8bcb69843608a90f3b55c6a2967a582833a9607"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a2b4896927d666a0a5b839657db00d6facbf090b67d5674dc5f931ae3364c46"
    sha256 cellar: :any_skip_relocation, catalina:       "781d78c5be6ca988159def596c97806badfb89681604f82d99bb643e67024fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836eb15fe5df898f8baf47eb09cfc0eebdf57f8df935751dc7a55c5b1d5b848d"
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
