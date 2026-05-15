class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "d671d1cb65808ddc8e82be9933cafd69071afe68a4acaa575c91efe980019e5f"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a41e20b99567677c3d422c02b1578600603a2a6ebb1de1b5e4d9562fdc121c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a41e20b99567677c3d422c02b1578600603a2a6ebb1de1b5e4d9562fdc121c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a41e20b99567677c3d422c02b1578600603a2a6ebb1de1b5e4d9562fdc121c"
    sha256 cellar: :any_skip_relocation, sonoma:        "475822f2de605169e00a90b025aca5af5d77c334a34a9c328d58f3ca329edbdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a04124cbcdf234abc6f8d5b999713d7f1cf0dc91949c406e84c789c4aa68e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de64b89683079736b6f71867449050fa4e15d101f8f8b60172c589475f3d0446"
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
