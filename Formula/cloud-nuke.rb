class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.16.2.tar.gz"
  sha256 "86866760a9bcf872a497fd3b227c56119ef09f4333ab5c21d5e9e918c19e1858"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020fb99661394d4c42e94571d46cfa24746cafc2244a542e9f1c3a071c5c24de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be608197e6c86fdc7abe07fe9c21042cf9375147bc3c61e6f820fa389d4ec23d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa24d6eaa77a70a8205009e28df570f6c2f2cfb05dfc5a1640f0dd8d9f7f3252"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc62634c197531ef18edcd461114636b167f873252b2bc86dfb5c7e50810da6"
    sha256 cellar: :any_skip_relocation, catalina:       "c95f6c2257c446ec2a7ab05ced9490673a77f7b52be568d43a7329390786e70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c394add28d50bbcccdc80cdf406f0f86c59fe8246578d08831aa4878684aeb"
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
