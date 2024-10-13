class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "163947cc9647b267f4ad52be04b27835d332b81e97d2fafc7ff583ab17932aba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd5bd2a2ccae4ba3ea9a11351f784a716f6c04c5d19ff3550ead3ad65a3fc374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5744688092b131063e03cff3e5b4296454034a676969ce876f2a60c20098ffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c5f8b0819584d6ab7fc754c00fba6378e2c516b6a16892e2b61b6c0d6b94cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce1925921de92cfe8c090ed7ef3feadb73d4e35096206522c35f072f73db0dd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "04a14bf2456b204fb19af32f48b82fc516beb70c4b363f6d529f135463cf2910"
    sha256 cellar: :any_skip_relocation, ventura:        "8b666cf6d66317160e4c2d17b11305fe42bbd1d5ad906153f276ec74eb4d0a35"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5f928741816c3d2a24216a30b3cc9dccc3c21a3beddd2887e5e63e69af1877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a2bcdc53dc8f8a42ff0b5d9bcab9041c736a8b9638c3da96fbbf55d354e2e1"
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
