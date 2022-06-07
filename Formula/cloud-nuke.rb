class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.7.tar.gz"
  sha256 "1c88ad605ffb1d5eaf60a8261d3da90a36f386bfe1082f8a7aca3cb15732e605"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4637b5299956b4ea9a3f4a468f569a0ead0f8704ef04d402e23e2f3e333c611f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28f1b26b5d45d60abba4f17c0e017614458c8ee5f8128ca4c6c71ea46c35d4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "77c7f679d5245fd49edb7b30000d86bd7175b83fdb573bef53318c3b1f0dc73e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17ebc25c49d364823da8f6a2c049ed8cdb9c3bcf8389963d132fc45e642eea59"
    sha256 cellar: :any_skip_relocation, catalina:       "5bdaa90d7a6576ccb9a846a8894d4f7849217ad827f6f1432987d05eaa3d84c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91ce701af2d7966c68ff0b5f5852d530f914f2e9721dafa7d2cfbc8909b8c1d"
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
