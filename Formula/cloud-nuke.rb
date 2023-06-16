class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.31.2.tar.gz"
  sha256 "dc0d3737dbf0ad06c5ab2be0585797f6a577b3d4e701d859466f146af1361b8b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6fd256cd51f3843549d7d0c979e5b9bbddf4c78a1b56e0a61446a06fa6ab2b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fd256cd51f3843549d7d0c979e5b9bbddf4c78a1b56e0a61446a06fa6ab2b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6fd256cd51f3843549d7d0c979e5b9bbddf4c78a1b56e0a61446a06fa6ab2b2"
    sha256 cellar: :any_skip_relocation, ventura:        "8a3ee6222fcd108bdda376ea53fefc6e2bc1072cfc651bcf8bacd0dcba5f1c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3ee6222fcd108bdda376ea53fefc6e2bc1072cfc651bcf8bacd0dcba5f1c6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a3ee6222fcd108bdda376ea53fefc6e2bc1072cfc651bcf8bacd0dcba5f1c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f99d9811146cd92b3ad0554b1ad7f2227106212e121b94bd22f7376c2c8146f"
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
