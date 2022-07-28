class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.1.tar.gz"
  sha256 "7a80f457ee15851c7a8828ede6d40ad052654e36f86a3a582cebc7a28b9ee12f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34efbd2e17ce5bc1833f30075cfa74da7e9a5fcc1e22a19ea5f0b780178b23c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1c98904291d749cbe8241248e1273c546890c48955b44018721247588f7265"
    sha256 cellar: :any_skip_relocation, monterey:       "3e95040459c34ba3b6cfd5552068d82010c53ad0fc4c8423c743f0363bf16442"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96d7ff285da8007a6cedb960255f273e8646ef0822d2fd2c3c3babcb604aa65"
    sha256 cellar: :any_skip_relocation, catalina:       "ee109548b8134701e4b5a7c1dd660ff9f1fae87049b03b31d9dc2369a6111ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116331d201da0648ec2e3253ac141beac7f21840929393b79499690f8f58618f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
