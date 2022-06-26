class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.15.tar.gz"
  sha256 "47423d4ca3baa95bd0e1b134ae90d5d5b859fdebe74a2b7057c910e50dc4dfc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242f729258f70187546935e540a4ef94a6c2de614df2942fa74f1458e617f4ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00cc4603b9db1cd0f3a7a54e5575cf0f8330e5250276d3fe09bf790a8b302f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1d1cfcb4f9485dad13256a549333eabba50ec78e8c99d1645b15ec1dc64085"
    sha256 cellar: :any_skip_relocation, big_sur:        "255b4003b08ba59700521c4cc16cc9723f2ad1dff089eae714a902c04a3f3dc6"
    sha256 cellar: :any_skip_relocation, catalina:       "15d59127cba07b2f2a35884fc6ff412bed673e0ad499ee254d520eb5d6d9d511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f9d1ae48748c815e2dfd716e732b967cbe807aba1d4fdfbcd3f5f7befe3ac8"
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
