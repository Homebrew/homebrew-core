class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.11.tar.gz"
  sha256 "4ff9a5f45241aa2b4a4f96e7035b6b6e9ca46b46fdee97425b777fe6f2d62ea7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56290c79defd84bf41a17510ab23239e133c8cd8fbc03a7c26b3447b8ba5fc78"
    sha256 cellar: :any_skip_relocation, big_sur:       "13acd68e6ebd5170ddc09181a7be6f4ac5b088fc493e98599246088fc2c1ed9a"
    sha256 cellar: :any_skip_relocation, catalina:      "8c245e35f273782f100f3210853752272b3e90b47d4f49864334b9673c0c1c3b"
    sha256 cellar: :any_skip_relocation, mojave:        "1439271cd8b4735e3393db270e3c3e10eac2151194cf9c1492867cb7b2969d54"
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
