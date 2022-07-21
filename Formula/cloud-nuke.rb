class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.16.0.tar.gz"
  sha256 "890c027992bec1586c2fe35ebdf70df4e925a958c8e15318acf7c6864c009fad"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf7f7c0aaafe5cb0f2c8c978aa511e4513f15a362254af5d810f4f56eb838bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "352fdf95733a4f1353b0c75e556046daf2924b9a62a9d20ab51ba7ae78e87f33"
    sha256 cellar: :any_skip_relocation, monterey:       "32313ca2d0a49e4f7e6b937f0196aa94b23036c9d46842106816547f1fcbf0d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54a38961dcb78c3c1aa2147871ee3e1073719993582cde5b5ab580685a416f8"
    sha256 cellar: :any_skip_relocation, catalina:       "f289b5e158715398285b5a673e636b6bda14a8ff8a51bbb588efdf1ea6e92d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce4bcb696e9a82a5a1dcd5ba8093128c4bae2a7300b3fc09b433a89b6a55b8d2"
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
