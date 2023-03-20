class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.4.tar.gz"
  sha256 "2e88106f8726f98259463a0464253caeb9d128365629d7b6c8293fc59477cac6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b62849de04d1224a727798abfaee89f8bd4e070e1da4ae9f3728b70e6c04e03a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73af27a8248f5f01a995e9ebe041419a8023a8b1b6e0678be754bba897926c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aca1ad133cac981f2841f38db10a3b0bc6616e927769877459e2b3d3ad18fcc4"
    sha256 cellar: :any_skip_relocation, ventura:        "510aee1ae3214707fb1f6b29853f64703588f816a877b9f51f15a7121db359ed"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef4683d1c7d9aba3acb11a9cfb2a18fc0d39464d321c60e6340a3662ef22bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d14ab6bb827388275d86de008428fd32b8b297b7f1e0d61f38b35841db775bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "869d61a02e115f90b2f74b37eed51df61191f4ea61cb70a766040b2c53590969"
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
