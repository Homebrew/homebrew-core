class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.6.tar.gz"
  sha256 "8ff74751f519df2c6da1ba5942a954e0b972b125dc622172ea15bb7ca13bb04f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f73982ee11bf4068c40a9e915bfac9d4a81538e769cbf62bb053d74db1cd838"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f73982ee11bf4068c40a9e915bfac9d4a81538e769cbf62bb053d74db1cd838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f73982ee11bf4068c40a9e915bfac9d4a81538e769cbf62bb053d74db1cd838"
    sha256 cellar: :any_skip_relocation, ventura:        "9b5f158562c25f1381f755199e65c04e00eaa82daef9d30cd4e2f2f3ffa3e2e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5f158562c25f1381f755199e65c04e00eaa82daef9d30cd4e2f2f3ffa3e2e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5f158562c25f1381f755199e65c04e00eaa82daef9d30cd4e2f2f3ffa3e2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d49134fe89fe4c7dbe7f4c672ac58602d6dca8eba29329acc86b0893aa900ef"
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
