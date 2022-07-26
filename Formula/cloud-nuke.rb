class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.16.2.tar.gz"
  sha256 "86866760a9bcf872a497fd3b227c56119ef09f4333ab5c21d5e9e918c19e1858"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b373a16bfe5e2c989264288acff63d5202907dba1cbe1dd99d151ebb57667544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b87417c0a420a7cd42bfdbbcef4fadc0d507a7f4ab836862420086f1b680d23"
    sha256 cellar: :any_skip_relocation, monterey:       "f7bd745a2b18e5e34c563c9fabf731099446ad1583eae05810582a3c39fd01ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "7de4045b1adbaaa7055ca51ffa0b2a9f91d2041dd6e452912b240c7076482046"
    sha256 cellar: :any_skip_relocation, catalina:       "0b878921468b0280ef3a1655aecdc3a7ca9cbb6513f69dd7576416c2b6a3b0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5241dd2e4830fadbb37645144c8fe95b9c53adb397b2adcab466fb06f5305e42"
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
