class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.12.3.tar.gz"
  sha256 "feb6d8b094c01e5584966910bd066d5e6feba4f7fc1bea97deebaac011afb3be"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2a5aded50c0bb637d91f71423ca21e7410d5090b6590f8447090234239d2dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "187b3b6bd2848e27fcfb6307cb2cb8386947d6f9119e5dc83c6badd9e7e9d4d3"
    sha256 cellar: :any_skip_relocation, monterey:       "073730e960accb14ff966afa81416923acfaae2ba553157d480778c5127b4aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "de21afeb3ca02f560ea562cea8dd158ee368a7193ff5d86e370b348f447f02e2"
    sha256 cellar: :any_skip_relocation, catalina:       "558525458b28224f0e735da1abf63080208684ed97ba8559c7e057d0342500a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed27b09548553a673128b4cdfca2302571f5d1ce4e5a11a35ef99df442fc69b9"
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
