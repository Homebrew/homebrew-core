class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.3.tar.gz"
  sha256 "071c612c63282fbc0f1b5ab6dfd4cacefc8b29cd1501fb5063a43df704e04a89"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f1e7ad0e53f62d181264460152441b8cdc8fb0bba2e40153fa38bf91bf1587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4540bc608645afd9f36bf914d45d85f28b8b72fc99ea6cacdd224f169d7a6fd"
    sha256 cellar: :any_skip_relocation, monterey:       "64626fe2e8e855e4c91d253f2c9e68a5da0f51927a5f9c20ee64823965f9e405"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f72a9b2d79e0f94b2320ce7c8b8f9d1984de1e209af4d90c3cc968880a0bf11"
    sha256 cellar: :any_skip_relocation, catalina:       "93fd75d689a4f4f3e2ca8945525cf5348c7b2f606997a76fccb1e22991c84bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d109a1a08e0131abf773346506e6de9bcf1ec2482b3b8ee189e680d77d6cf9"
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
