class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.6.0.tar.gz"
  sha256 "95e8af7d0efb006efd7915073440fa5b2a8fa4576c7673057d1f3cc90f29ee99"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad089a0141d64f629ed72fe9fbfe06ee625ec5967ac9ce89e7248558fdbff7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a6583a82daf22f4cacac7ae693f085f6dc073ef8938b07a746b81fff8f8a862"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e9435e02c1d7cdd5e71767905f4fb732a65c7a546794ab45afa986caaab9e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1a752b3503c117e787a07f01604bd6eefe3a8b6a05114c93d8e1686abfcca6"
    sha256 cellar: :any_skip_relocation, catalina:       "2b58cc27ef40742480e5972be570926af1037d9f8169776100843e678f9aab4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a8fc756e65cbddb03c68619057ae9215a23fbad77e55bcac1db61f9beef537"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
