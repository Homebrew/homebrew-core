class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.7.tar.gz"
  sha256 "dca9450320c02fc5e6d3b06d157a9e9e683b74e00f0658bd76894031ea3907e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a674e0b6c9a99cbd58283278a3cea9aa27247b813439f3f5610d9a9d0284db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a674e0b6c9a99cbd58283278a3cea9aa27247b813439f3f5610d9a9d0284db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a674e0b6c9a99cbd58283278a3cea9aa27247b813439f3f5610d9a9d0284db"
    sha256 cellar: :any_skip_relocation, ventura:        "1f4f77f84f9d30a4115b304778228618ed804c7338386b72418a6629d93afb01"
    sha256 cellar: :any_skip_relocation, monterey:       "1f4f77f84f9d30a4115b304778228618ed804c7338386b72418a6629d93afb01"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f4f77f84f9d30a4115b304778228618ed804c7338386b72418a6629d93afb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dbd89121e31ee6af74b21850b2deae931eb5250b6e4b5b1c2fbd6e4d17c4975"
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
