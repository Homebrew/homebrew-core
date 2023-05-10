class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.31.0.tar.gz"
  sha256 "ead1ad9e17fac76c3ceb6af1e27228674a603be550b79e44084c9374f3e54bea"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5691c914ecb7937f3364a8c638f2e995ad86a13b8456bd55fd47e6b7229d2c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5691c914ecb7937f3364a8c638f2e995ad86a13b8456bd55fd47e6b7229d2c9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5691c914ecb7937f3364a8c638f2e995ad86a13b8456bd55fd47e6b7229d2c9a"
    sha256 cellar: :any_skip_relocation, ventura:        "dd2b567caeeec8f5b3f4a7ba94cf4242956c1a9f3a50b43b0ae02655b1ec5e64"
    sha256 cellar: :any_skip_relocation, monterey:       "dd2b567caeeec8f5b3f4a7ba94cf4242956c1a9f3a50b43b0ae02655b1ec5e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd2b567caeeec8f5b3f4a7ba94cf4242956c1a9f3a50b43b0ae02655b1ec5e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed2389f4e4b8319bdf7ef0fbda02896dd81b9964986e689f975c8dd8d80143e"
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
