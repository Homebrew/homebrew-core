class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.0.tar.gz"
  sha256 "e785a4e8028f190c0ecdd628ee46aa8ac99baea87ad437098aacf12bedbca98d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355c0ecaefd1f0414d21dd02ead91be72a880f7adb3f37d9bab39b8dea9a9e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "866b0e9322b1a4ef52c4df0b6a3600196cdbd589f2a9714d59d88b260376c7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "c8b47404ff37302e0d6104eb18499354b6f007c87e33aa46f7ee6b47f7c7e63a"
    sha256 cellar: :any_skip_relocation, big_sur:        "02f8913b0ccad3d07c1f67957e908e7b493fe880e3fb4726c3bbdda563c78c82"
    sha256 cellar: :any_skip_relocation, catalina:       "32f3313268427cc680f26b8cf4af11b5d7250348546f890b9d8fbcb4fda09192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130cc74f040f2eaf2682b24e6e1c4ad7a93c7d55681808d664644619ce90cef2"
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
