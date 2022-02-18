class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.14.tar.gz"
  sha256 "fc9697645d27f487c8b6a2090c7932214a8935c4cd59575dc8969aba0923ee34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942ea3612d4571866bb5d673ca4dd909b64b68ca74401f3fac2404a5d7fe23cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9e3f75f443d8010f58d0cef966358ed01146b324b8c0965204b626bc53a84c5"
    sha256 cellar: :any_skip_relocation, monterey:       "d042594dfeecd76a9512ea4704f63ea74188ca0469507b854938c5408880fd9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeaccfa7730e0200449c64181de8c4380543721fa89d234c585c8f905b0ad6df"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e2a865a2d67839e4562e2261cb47e34d72f57ea88bda57551b2af88530d5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3734718184e6045a7f06d9db4b1cb86fe800d4192691a331d623441059d74d"
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
