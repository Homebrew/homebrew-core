class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.10.tar.gz"
  sha256 "890e2105ef62117849fdf740d753b6b436b2989a108054913ebeb6b0d93218eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c51f1e844493850d697f42e6aa8280cc6213e116fdaa8aa6dead943a36fe99a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "651de0bedcb62ebe310f632c2e5c547b2fca5f327079435fc3b604669c07e40d"
    sha256 cellar: :any_skip_relocation, catalina:      "5895fe76b021e4deb63b8a9eafced1666ee519b7d43c9447087d83884dfd74e8"
    sha256 cellar: :any_skip_relocation, mojave:        "f6a8f1d3f4f126ada1a17ec179712eec50f2457a0277c62ae06ea1e697d32477"
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
