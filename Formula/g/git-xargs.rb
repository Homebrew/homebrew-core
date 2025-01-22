class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "1d580862a29b29aaba09747b7e4af4ade6c3f9f93792d9f75b050a30bf9d66a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "475419ebe8700d6daa56148ae3bb54f7cff40bc78365e9955561642d6073b699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475419ebe8700d6daa56148ae3bb54f7cff40bc78365e9955561642d6073b699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "475419ebe8700d6daa56148ae3bb54f7cff40bc78365e9955561642d6073b699"
    sha256 cellar: :any_skip_relocation, sonoma:        "320aa7ac38b537ff09fbc82b1b46483842d70b23dcf2169c8742efa1c1453aae"
    sha256 cellar: :any_skip_relocation, ventura:       "320aa7ac38b537ff09fbc82b1b46483842d70b23dcf2169c8742efa1c1453aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e77ca1763bc592ef4b9a465e0eb09f068c22611010f53727bde7a7785e490e6"
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
