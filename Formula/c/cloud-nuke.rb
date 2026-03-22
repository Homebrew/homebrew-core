class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "6aa9dc839644fb9fc23e17f7c614a6232f9eb6f5f4accfaad564f729ec2774c6"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b81490fddf65ee581295217a3c976aa81853e1b90351c5617b231876f85cd39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b81490fddf65ee581295217a3c976aa81853e1b90351c5617b231876f85cd39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b81490fddf65ee581295217a3c976aa81853e1b90351c5617b231876f85cd39"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9e99b0e05a43b5e302d4bbccd49fbb33ad7af9e18e82059e10b671040a779e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b19c4bd24648c82f95896a557cf9beac21e407b7c1703d8443ff54690e4ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee2b386f1e4aab54d9b71a8a3832a4946162a10fc76f5dcf744bd25ed5261c3"
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
