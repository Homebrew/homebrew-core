class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.7.tar.gz"
  sha256 "1677fc9b7b3346e7816da86fc01e9f647141868652c102ec9655a56a7caff69e"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0153f7034ea8baae16c984ff217cd74e88ffa1b2d9ac26c42155e61fbe48cf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20da5a7eccc63d4ff802e1cf868bc61220c9a9688e6e72ef41845bf7aa4216a"
    sha256 cellar: :any_skip_relocation, monterey:       "f301e2b902317484c870ef0c479c5e364b42d3993879d09415702ff853d689ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "045418558c4106727e1ebda7d424458b9b176ea4670d86a1d05d13302c862108"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd9d3e568cff578a7e21ba72c8d17b097cd86fc157ad231e63640613fa24906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2f4fa5a8a12115499789c1faad7a570039be636fe34284a71470a7686fdfe5"
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
