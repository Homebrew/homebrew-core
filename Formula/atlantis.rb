class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.1.tar.gz"
  sha256 "4fefe422c769a5d31d9c280b447b4f370308ceee23ba579f2d43bffd72853c76"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d93a6b1fdfe03aca6e3896003c512c828871e5bcb9ad4393426cee18eefa075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd94e96c0673675ea478f2011877df922c4b38409b4e639e3ca04e682d9afc5d"
    sha256 cellar: :any_skip_relocation, monterey:       "d2b0febb43f0822ea0c6aa465be50fc7aa18ba47da4f3212cd423d13d23915ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f60ebfc43beb28a8f05074ef883161944c0988574fd78cf33e5aaee36a329f81"
    sha256 cellar: :any_skip_relocation, catalina:       "3ee48a7e588d109b00603267d4171853b4a5a7dc4604bcd09922fcd0015350e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ae246306a5c51967553eeec5fc63b3c13436bcef75c93bb1dab55fa8923233"
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
