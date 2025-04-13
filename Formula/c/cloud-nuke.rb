class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "6b03dc2949f48b431fa05f17481b1dd708754f658aca568f1df8f54cc616c73d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca960e1b4c5ca336141935436e9f0377d77e28e1c1acf3fc7585d1d27e0673e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca960e1b4c5ca336141935436e9f0377d77e28e1c1acf3fc7585d1d27e0673e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aca960e1b4c5ca336141935436e9f0377d77e28e1c1acf3fc7585d1d27e0673e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb15fd28bbc36b164cc447b494afab568f36a0373d5d002cc5b184404a3b17a6"
    sha256 cellar: :any_skip_relocation, ventura:       "eb15fd28bbc36b164cc447b494afab568f36a0373d5d002cc5b184404a3b17a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da2326254501b214919ccdfe3707d3cf73f1b5021c74627e9c3da4c05cc2880"
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
