class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "93d5982c209e76b88233deb610c9a3720a7f0ddd3f3dc66f389338b2f1e0f709"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46d81f2749b43600740f65cc1679ddd0506fe03b5b33bd1dddac47f34f9cf10f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d81f2749b43600740f65cc1679ddd0506fe03b5b33bd1dddac47f34f9cf10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d81f2749b43600740f65cc1679ddd0506fe03b5b33bd1dddac47f34f9cf10f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef45ab2f3b6c234726a27fdd86469604f77944acdb76f8caba1e6b473de4e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb655705a885c1a3662343a4130f04b012f112b9582e9584fd133a24cb3c3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0765b0790ba49657daa9113b9c8defad2fd2206b7c158728206666a754117ca5"
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
