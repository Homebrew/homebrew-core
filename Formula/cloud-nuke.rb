class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.16.4.tar.gz"
  sha256 "9e1b425b997ef8e737f8440ebf50ffc0bb59f8892b9fd5b1094cedc98e01dce3"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9653a6ce611ee0faa50ddc4f8b983a94a9b7fbb462990d486b75caef9875b397"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd3103e213cd9a32330131dafc2dbea312672ee117fa97c07993e6fed228400f"
    sha256 cellar: :any_skip_relocation, monterey:       "ba698f83a98dcf2512a41c7dab5d8de36a1c864d1252336e07839be12ddb2815"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf3cb4a7deaec1062f91be40dcd2e789b7707613576294bbe2037a9e07d550a"
    sha256 cellar: :any_skip_relocation, catalina:       "af6e0d1a75ac9285ecf8111ac1e6620b4b75a61c4e53da86e43b8e2baa2ba1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908ea185f7d4142310169369816d0ad9065e0318780bfa78fdbfb060e5f40ab5"
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
