class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.7.3.tar.gz"
  sha256 "6faa875ae104371c9fedcfb42f983dd0e5181d2b7576fb56ab9647b5ecae8c89"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf5c3172502e00a96f08682107eebb7e46fa3d03df7a33ae54bcc34fbe68b4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d17acb3a4a056a9512d61948697171118f345ebac42f176e7272ad8c970199"
    sha256 cellar: :any_skip_relocation, monterey:       "4a629a9b10c99046c78e6df9bb6294c7a308099486a75e93570ba075f51e4a2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5031c48d441438146613f9bc365d48e17ac82057dec2f517cd27f64d1748a071"
    sha256 cellar: :any_skip_relocation, catalina:       "24edeca062fd2b117bcdaf99f2f18280dd35aa40cc604cbb91df679cc1e44963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a77d57b5ae133415b7beb0e9be93598752c0b7e676a8d31d1486e8f1345d461"
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
