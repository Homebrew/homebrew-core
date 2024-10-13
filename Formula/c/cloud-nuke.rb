class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "1d194b939728834c84f2e0c1816bc46b6387a13b31f71cec271215354f1a4b4d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7c6a5449d5157cb8989f7ae11c279a0fc3abfe7f3f8b4d4d047ce9c0ddf419e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6053961d6d512fe3d4753e385383758c2f61bdb2a9fe4fec5cffe0693f87af60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6053961d6d512fe3d4753e385383758c2f61bdb2a9fe4fec5cffe0693f87af60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6053961d6d512fe3d4753e385383758c2f61bdb2a9fe4fec5cffe0693f87af60"
    sha256 cellar: :any_skip_relocation, sonoma:         "a62f36260d992044f6a5a848347371471bf644c0ad46c7090126cf7759822749"
    sha256 cellar: :any_skip_relocation, ventura:        "a62f36260d992044f6a5a848347371471bf644c0ad46c7090126cf7759822749"
    sha256 cellar: :any_skip_relocation, monterey:       "a62f36260d992044f6a5a848347371471bf644c0ad46c7090126cf7759822749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ce10a94c5162cdae5069f427c2c39f6d560c990f772a45b00aee6910d89e46"
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
