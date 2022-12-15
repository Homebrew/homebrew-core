class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.22.1.tar.gz"
  sha256 "bb3b8825a6d59c39cdd821332fd2a2e5e5d6df54615a9f4937f0fd633f8b8db1"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f7b46dcc0f9b93941b4303ebdf4739c2125e01a1fcb06b22969282842527e3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e43f3a6a9ea74b4f539971afe0845f572a1e1be7ad68a6d47d8cf6ede3fe7426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ae8c0a7b8b3737fdbbd48b46329375d6e83ee964f017e6190540ee6c3984e5"
    sha256 cellar: :any_skip_relocation, ventura:        "530e536a374a615c2fcdd077d2d37137c11a666d1cbbb882d75b4aa3abcff801"
    sha256 cellar: :any_skip_relocation, monterey:       "82377d8fc05d6f2146fd827ba282b6c3ae5e475dfa791dc1c393f4c7cd69f984"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dda81c02404d3bc36ce2d7e516b94166edee6d0af2fc30858aa078d25edf66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6924504a7a55e78fe93f1f9a4ec17c32d9e65684e3732f5afda7013beab367"
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
