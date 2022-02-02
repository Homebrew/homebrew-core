class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.10.0.tar.gz"
  sha256 "e84805a35b247959ffe84a521747dc74c4439bea34228fdb5cd48cc32b50e314"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c1d2a7dd22134985466b54e696d80c5889f8bedc8fd5115b9e2526368b4831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966de4a6fd68e4d8ee422fc81fa55232f4f7b9f31bc5bf2d8cb8b3095515d132"
    sha256 cellar: :any_skip_relocation, monterey:       "cde49cb54454acd214ef97ab7478d13ac75f775553a9a00409d210feadbdf6cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cfaa16cbc986e670e5c90e33f9858e29e07ef2d68fd9eb3991aa142210bc381"
    sha256 cellar: :any_skip_relocation, catalina:       "5afa2204bb3fcd6403cc0e1ef2e8bd822d6ebbb3d2656931c23c99528e010c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c062ac3e3b7f59cbec9680cbcdd9a518b08c55ccab8666353995d2cbea0f3c6"
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
