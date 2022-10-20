class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.1.tar.gz"
  sha256 "7a80f457ee15851c7a8828ede6d40ad052654e36f86a3a582cebc7a28b9ee12f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e49c58def0241dd26f019c7f8a38389d5c4757adadf5c74184b270cc95075ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38fb57824be03c96ae7e20e152ff3f7fb6ced837d24ec247e518b19180d82358"
    sha256 cellar: :any_skip_relocation, monterey:       "4aef9183e49fbc62af2f588575bfa59959368a02fc0195340aa16eb14edcd9b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cbc68ea2a1cbacf37f09c027c9b6b6740e2d0a49b6dd8bc55702c3d9bb74e1f"
    sha256 cellar: :any_skip_relocation, catalina:       "d674cebe3eec7778d00e7654249f09d991934f75b1e6803bfbfec194b7c71824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe672f7648fea6b0a09432219aafb9c5f9b68271a5cb39b4e8888f0ec8c5956"
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
