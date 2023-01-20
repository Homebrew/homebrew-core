class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.23.0.tar.gz"
  sha256 "5445b60d4ec58d9cd04bc40375913a70825b86b47539cbc085be5f51b6ab6c6d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0ad9f771157c11be427c2b353742d3f34f52e82cdb1dfadb8146b04e9254e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54bcb22cd01cf3a3fab52c7a1432372eea0d6be03d50a1dbd3ed6839a2c64ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5c57ac1dbf8383525e042819984e9ead960346f70a8517c87634007f9b58f28"
    sha256 cellar: :any_skip_relocation, ventura:        "6b1f4092f463fd52d84d9240a5ad5d5cbc59c183842be690e848294de5608050"
    sha256 cellar: :any_skip_relocation, monterey:       "cb54da3586a316c6329ca9f5a180ffcb94cae3ad2878e2707440f8480f53cce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2dd0d884cfcf6cc038533daf0b2c7dec21ab2b890540592c66dbc13873a1832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e38d42f6446196dc6bb4cc86276ff92d42723a05c3f887f5d84b9ab40ade92"
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
