class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.14.tar.gz"
  sha256 "fc9697645d27f487c8b6a2090c7932214a8935c4cd59575dc8969aba0923ee34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc69d54877b699a292e71da84ba51b62e0d01a469f6a5b04289459baed4f6c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e1429fad3ea227e98753464e2d4d4d333e8df700d36c5c94c8bd0905fd347a"
    sha256 cellar: :any_skip_relocation, monterey:       "0f8e5a3375f3c3f361319cabc21d2c487864eab526332f4ed9f777a0be6bf8e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "95595a6af5a65058b34aa647d11ddc1689803a7057e04e9a493d920a1df57baa"
    sha256 cellar: :any_skip_relocation, catalina:       "babd5c78e544dda1dfb28f098dfcb13bfe96286845a6f19cb64fce410428b0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3be62afaae446a8b9e917a697696a1f3068409162c15179986d687af65e8408"
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
