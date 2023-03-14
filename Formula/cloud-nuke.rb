class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.27.0.tar.gz"
  sha256 "e9dbd708223e115c6b9e179df3e8280df865e41e2a82aadfbcbe68b6b0d1a305"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2591aeea84e255390ce99c782add4bcb1350cabe755b631fe28fbc6546f12f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2591aeea84e255390ce99c782add4bcb1350cabe755b631fe28fbc6546f12f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2591aeea84e255390ce99c782add4bcb1350cabe755b631fe28fbc6546f12f4e"
    sha256 cellar: :any_skip_relocation, ventura:        "be0e0d667496f05ac1a7ab26f73ce5718507c68e633a2a8e28437626a5820c98"
    sha256 cellar: :any_skip_relocation, monterey:       "be0e0d667496f05ac1a7ab26f73ce5718507c68e633a2a8e28437626a5820c98"
    sha256 cellar: :any_skip_relocation, big_sur:        "be0e0d667496f05ac1a7ab26f73ce5718507c68e633a2a8e28437626a5820c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85993ac74073d8437213e815e4d89095b2fedd871222805873487a781a6e18a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
