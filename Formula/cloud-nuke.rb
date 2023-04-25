class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.7.tar.gz"
  sha256 "0d117eae7afcab197fab9e0ca2aaa5db8687d01e8a16ed436b8558f820ff0150"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c021d09ddcc3e6a13caa811d523930c62c11529afd69640c1931984a9d57d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc676d15c4df54161f0422c231b89f71353b388ed051289909d222c83a279e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67c5472d449e300bcf61cdf47883ab24bf9fdbc8fc8ca08e9dfedacab73e5680"
    sha256 cellar: :any_skip_relocation, ventura:        "07b24de80ad30edd949260128b325a84689c87a92e3a79bce0a547fa3ae43172"
    sha256 cellar: :any_skip_relocation, monterey:       "4d18a5ca8c3eb3dbddf6e0c96a8fcb5b4a2d9fa1ea8cbcfccb2ce0d92b6e5df0"
    sha256 cellar: :any_skip_relocation, big_sur:        "625d399f402d11d44e29742a96851c6d31a97a6e3fc8e5f4791a3883c1176452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac9fca2e31e854ef759bcc14cd88acff93463aff15b8e6c9356ccad778a0eea"
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
