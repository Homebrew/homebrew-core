class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.12.tar.gz"
  sha256 "8d9f83bdc3ddc95f2536d2a437a5b8146c0dc414cf340314313b22674b2de399"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "136d4fa8afb265d78042eeec45dcb1279e80a34b235879be157cbbebb2e0dfe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47225d4785202b3499bc97693b539be5362851f1f346602893eb090bda6b2a67"
    sha256 cellar: :any_skip_relocation, monterey:       "35e27b59738ab84e26c63ee5bfa64c2b859f9b129ae0035d1e5fc1fd7817cac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fad89e4c9489177bf11e108168a40b3657be3c907555978c3b493e21a689724"
    sha256 cellar: :any_skip_relocation, catalina:       "a1c55c676b31bd5b6091c501fbd5acfd68224481fb9df99324dad3ef99d50188"
    sha256 cellar: :any_skip_relocation, mojave:         "2b07adc350713b630a650c9b95c3e12dcdcf87cd4119adf0e37d84c81bcec179"
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
