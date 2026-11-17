class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "a17816d8998aa756941117d987a9febd81f36fa870b2646d40f16e6007bd2698"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/git-xargs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8480909282b212d085f048eb9294a5e6824309cf7415ca8946b6616161f9a3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8480909282b212d085f048eb9294a5e6824309cf7415ca8946b6616161f9a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8480909282b212d085f048eb9294a5e6824309cf7415ca8946b6616161f9a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7acc6e0a9a31eeef5c314fd112425f665d0b1b2ce1b9671e0f8db8185223abf4"
    sha256 cellar: :any,                 x86_64_linux:      "765228ef246882653c6db70f5eb97323752707259efcde6db454044da4bbbe99"
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
