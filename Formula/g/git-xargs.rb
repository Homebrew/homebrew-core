class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.10.tar.gz"
  sha256 "316021d2c2e676acea7a44dac1ddc1964add5b576b1830bc2116fd8be2a38dda"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f44c6ea45fb6adb06b9cb326afa38154eb3b48cc0f961e63778fa2b2a36c550e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b2a545083fc33f7230ad54752503cbebe75f1b8a144cb0327a7644e538d4ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b2a545083fc33f7230ad54752503cbebe75f1b8a144cb0327a7644e538d4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4b2a545083fc33f7230ad54752503cbebe75f1b8a144cb0327a7644e538d4ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7ad994e74ae4f0d06e09858a3dc5069d6a0b06b88660d2f98e6c272ad8d934f"
    sha256 cellar: :any_skip_relocation, ventura:        "b228796b609314540bcda802d77a0c58ed2ade54ddb460bec389e1769273f68a"
    sha256 cellar: :any_skip_relocation, monterey:       "b228796b609314540bcda802d77a0c58ed2ade54ddb460bec389e1769273f68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b228796b609314540bcda802d77a0c58ed2ade54ddb460bec389e1769273f68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199d72651a5ec57bacfc8dffd387205bb4d83d94f9767f07706a0a4d8dd70a96"
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
