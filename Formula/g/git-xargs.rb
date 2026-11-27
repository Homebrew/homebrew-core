class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "23cedaeb706b0dc96a132b134e3038d79c88518aa590f152f531a7c38d37bba6"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/git-xargs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "25f0e16bdee9141189a561f1cea5e22ceed2bfee21a65a3f60b4b75c0ebbea18"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c608728122c94c773a30f08b805e7ca7818e2186a18ec2527b887b3bd85816e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c608728122c94c773a30f08b805e7ca7818e2186a18ec2527b887b3bd85816e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c608728122c94c773a30f08b805e7ca7818e2186a18ec2527b887b3bd85816e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38b3222297ae32d0e42ee6e24143664f6c20698fac2125535b6002c1c2514ea2"
    sha256 cellar: :any,                 x86_64_linux:      "36748c278f2a4c127fad0ba772c87eaca6cadec1ab932ea47559c414f8ed5977"
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
