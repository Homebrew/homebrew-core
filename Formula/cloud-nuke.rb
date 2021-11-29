class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.7.1.tar.gz"
  sha256 "79e05807b6f9282749eb4459e49c00671d76c7b0d87e234b6dfc949c634b283d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1c0edd97757d23958ade7f40f68dc3efd9a757724f91724cfaaeeeb7f59f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe31aee5dcdc0ebc350a3f03a807b798cd8b2e6cfbba0abc895f21104d581cc6"
    sha256 cellar: :any_skip_relocation, monterey:       "388223af6af90d90b6ee58f74180ffcc5e894fe839dc3a51f19d98578ce23e00"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e592efd575169f17123ef4b0ac472ad18c6309cedb72a6e345d58fb8ffddf5d"
    sha256 cellar: :any_skip_relocation, catalina:       "9eeab20bc75c932234c55c83ffd2a68e285bbb0958e0f742277f7c168b0433a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171027b0d68cd0a19d22b2958c8b149c35539f958c6eaabfa80927d27c8e5945"
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
