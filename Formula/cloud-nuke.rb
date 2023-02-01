class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.24.0.tar.gz"
  sha256 "ad33bb83290524d54aa6555cefce42b457322bea7a64bbfb5910f90ebdb5a9af"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c121eb2c1f48650d8e29c5b3c4d205af7dee74979f7595dd076c49c4f3cb664f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219c4feec4679200dffcc6b56acdc4241872e883c7eb07c24eeee1146fa023ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a823fd09d42e06107d52d49921a82cbaea202c447d5c04590508a3554d6cc854"
    sha256 cellar: :any_skip_relocation, ventura:        "832a46618eb44227d005b70e93f58643915586547ad3d7e47909812e3a025c50"
    sha256 cellar: :any_skip_relocation, monterey:       "d03a09d1689035237d838a1646aafa0fe1f8781f4274df9e72819583f57d5e99"
    sha256 cellar: :any_skip_relocation, big_sur:        "c548cd6d66b3b1adb33f55c2ed4a5bdf43483d2468942ef82ba7c3ad3710dea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668b6f99fddd29366c4a0a06b4964b73d17507306031491f044719e18e8295a2"
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
