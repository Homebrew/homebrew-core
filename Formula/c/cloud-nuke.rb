class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "0937ef8f5c4ecde6ae1fb4b213b71ffbdadd53177c03a19ccc3824c5f97f27ad"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5150a1666149862e2e68f699d65890682dec3ad378f9625cf7502f3c545890b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5150a1666149862e2e68f699d65890682dec3ad378f9625cf7502f3c545890b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5150a1666149862e2e68f699d65890682dec3ad378f9625cf7502f3c545890b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad4dc6da0f8685a63a3e3b2fa42cdc26103d6be8969a28c23383e1bcc42c86f"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad4dc6da0f8685a63a3e3b2fa42cdc26103d6be8969a28c23383e1bcc42c86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e523157c855240213d578d63bdedcbc3e0254162cd95e0735225476b7a7a7d"
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
