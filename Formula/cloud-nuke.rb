class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.24.0.tar.gz"
  sha256 "ad33bb83290524d54aa6555cefce42b457322bea7a64bbfb5910f90ebdb5a9af"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c70ac40bdbacb110834eee2301afa8504d72e043ff3814c8314f2a6ec749dbc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b0be782ce99792255d367a4595ea395c73d592de02f7dab3bfe3211de036cfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bdfd0f630e726212f3e1b8ff126ea4dc619e49c5fa3ecf84737578acf2c0812"
    sha256 cellar: :any_skip_relocation, ventura:        "f96056c622d6f211a43e9cd995e45fc101c7a454d5e98b1491cfdd5c2c67958e"
    sha256 cellar: :any_skip_relocation, monterey:       "78f356f07caf53cb1481aec67af65900d29a4277b9d5cedbaf56fbaae39526a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "74b75a7baeca2979b02bb2d9ca38b4ba92f3f091e0f527152549c53b7962e96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51131f063856c4f0a2f04265a3564a2a2af4c6e048c6589d190cfcb0c458a268"
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
