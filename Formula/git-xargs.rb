class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.10.tar.gz"
  sha256 "890e2105ef62117849fdf740d753b6b436b2989a108054913ebeb6b0d93218eb"
  license "Apache-2.0"

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
