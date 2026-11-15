class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "817ac170a5edd7ac392aeeb5aff3cb491699d78d702f4960fa2aa67eb87fc6b4"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/git-xargs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6516344745ff1ac9cc100973695cc6d5686f410198553c2c3f81d4261f3d1239"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6516344745ff1ac9cc100973695cc6d5686f410198553c2c3f81d4261f3d1239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6516344745ff1ac9cc100973695cc6d5686f410198553c2c3f81d4261f3d1239"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4103b1256e2345f4e04b24be2e7154415e39ebbf22188df7fce54143073d18e"
    sha256 cellar: :any,                 x86_64_linux:      "d6911e19bb0ad29f7a9c744de61021c206aa72413988786dde6e3e252fbfe611"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
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
