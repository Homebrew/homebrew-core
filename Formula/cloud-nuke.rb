class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.16.1.tar.gz"
  sha256 "a1eff3472f0b04d18298d1229b55f4739aa3a93d6745230f71cd653c64829429"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61fbd197c4a66303e6d029c4017124b883f3897814291f78b99b254001bc91d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f91723ab48ada3dea7404abaeda61a2575163558de2fea1da0dbb1f52d8726e9"
    sha256 cellar: :any_skip_relocation, monterey:       "633b29b5e840242ec32625d1cf9d7a14f225834b776ce39a53470652c8096d46"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ff27eb2f067841bb0f83d31d9a7a70a64e90ddc628cf45252264c278c69eec"
    sha256 cellar: :any_skip_relocation, catalina:       "6d4c97da550ffc04842b9a96bbd31e4a0b46b38a338b502db8b452cad1e47ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95279fc3993520a4e7325dcfb55adad04c8d49e7623a88c09ea03ecbc0639272"
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
