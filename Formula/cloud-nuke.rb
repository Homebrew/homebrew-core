class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.8.tar.gz"
  sha256 "b766b514c533c83e63feb3f291c5a426e71d556f9ed347e7aed326f02069dfb8"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054ff5143e3584f8ba91c8952e454b3861bcfc8aa5d95250299bfe396f5cc122"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb5b4aee43c026e109fafce3d2937311a43cb91391bd01094140026c40f4669"
    sha256 cellar: :any_skip_relocation, monterey:       "f68be2f464c8131a89afa25b39762812e13f5348edc5354beae0a427ceeeb1fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "77fc1ed5f70f78409b118b7e942c49a29b1e12f59296fb76a9138090e4a80893"
    sha256 cellar: :any_skip_relocation, catalina:       "2b837597bdf7d325ab5e414bed9028ba1431f65839616de0da0d47bf5a069bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a2f98e6dafa3dcf94b923e27f58119dfed8f809aebbb1dc2adea7628507bad"
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
