class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.21.0.tar.gz"
  sha256 "e27d036cf7c733cec452fbcf0c07d310bba8b62a470cc13af16fc58afb6f657f"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec42a5825c80d8740d19fbcc8275a062c47ab0441988b4e20d2a635e49d632f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c45614bf0e96572f0fbb377d38a543150ec052e27e7c855ecb180653a25c725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57fb0e0a6060f634a7a5b7b2efabcd27c0eef459d55bb04827893235b4361de7"
    sha256 cellar: :any_skip_relocation, ventura:        "8bc6048c38119cb47e7f6deebd90d458116a6766201c7f87187387659d91c9f0"
    sha256 cellar: :any_skip_relocation, monterey:       "cafd814c784e7a9d48a9c4deab10169338733ee29d434e30197cd4c31bb95d58"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3b864efb541be20ba7a70a27e25ead45ee8019356bbb618a633addb1aec26d"
    sha256 cellar: :any_skip_relocation, catalina:       "4bf7f9deac49bd669dc116832d3de849186990b65a70859b40a788027a25c81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9949a8dfed9601d798b6c9d4ee931876fd4950cd6272e2fbdf93c488cc6f83"
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
