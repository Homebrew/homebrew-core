class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "18122dd0b524064920a083937b18ee50533200425110606b6f204c0a77bd31aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167caf47d40b4ca8023166a57ca035387237769fcd4aebbb5d961fec74577cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167caf47d40b4ca8023166a57ca035387237769fcd4aebbb5d961fec74577cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "167caf47d40b4ca8023166a57ca035387237769fcd4aebbb5d961fec74577cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c85b6e85851c35895e61ab79ef5cc16cabb963f6b50a42d7887bd4b1309c1b5"
    sha256 cellar: :any_skip_relocation, ventura:       "7c85b6e85851c35895e61ab79ef5cc16cabb963f6b50a42d7887bd4b1309c1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f14cf4558666920c26b6cff51917d57c43843502f7ac81fdd7809ca3270032c"
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
