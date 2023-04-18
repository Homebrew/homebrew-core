class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.5.tar.gz"
  sha256 "5c36150810e433b401ed3c50e2a913cf24aaaeb46065d7b80d9aabb023b05515"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "112c7a31501ade74aa75cad0804b9110a8869afb7c017d4376edc8aeb68f95b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112c7a31501ade74aa75cad0804b9110a8869afb7c017d4376edc8aeb68f95b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "112c7a31501ade74aa75cad0804b9110a8869afb7c017d4376edc8aeb68f95b4"
    sha256 cellar: :any_skip_relocation, ventura:        "98e414259b7f7890a7ce31260f961c06c083399974d7f79af53366b5d690801a"
    sha256 cellar: :any_skip_relocation, monterey:       "98e414259b7f7890a7ce31260f961c06c083399974d7f79af53366b5d690801a"
    sha256 cellar: :any_skip_relocation, big_sur:        "98e414259b7f7890a7ce31260f961c06c083399974d7f79af53366b5d690801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c6fbb5bebf20a9ffcf01360970825871fb9d4c71da8a652c9671a774ea7fa1"
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
