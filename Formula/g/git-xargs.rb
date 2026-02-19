class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "baf43133e9b361860982f2c13e6edbe193f825af864ea3fe81ec54464eda1857"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/git-xargs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "792b290c1a85159a481d5ea219c3b3e5356d82a7431353fa0ce52918b316e971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6bc4e8e5eb6319a5d70c81c6a87f66fa20d55890b395e5d8a829c84c17cf36a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6bc4e8e5eb6319a5d70c81c6a87f66fa20d55890b395e5d8a829c84c17cf36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6bc4e8e5eb6319a5d70c81c6a87f66fa20d55890b395e5d8a829c84c17cf36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e638bfc967c4b2216e20dcaf486033b03a54be584b0bcff1751cbb5f5530344"
    sha256 cellar: :any_skip_relocation, ventura:       "7e638bfc967c4b2216e20dcaf486033b03a54be584b0bcff1751cbb5f5530344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce9d2b03709399f636e6163278acd6f178e9556ce207810e904bb4001e2f7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c79ef94b3c3a848f5e1265ed5a155b153d18f9a746b04f490899521f995d06c"
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
