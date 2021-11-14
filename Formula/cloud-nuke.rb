class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.6.0.tar.gz"
  sha256 "95e8af7d0efb006efd7915073440fa5b2a8fa4576c7673057d1f3cc90f29ee99"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb554bf280ebcbf3d3405af023d96da1695e7253be64a355f61651867d18d1c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eee736ac77b9362fc5cf666f8a0981aa62aadf75723079025e2efaa24fed69b"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a65e7992fcb02fdae3067ae2e2d1b9497be62ff3b1819e3a10fb5ac0936bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "79110cfaf032de5134fc8dec18a666c76ddba7542f385230106be50fa9cc28eb"
    sha256 cellar: :any_skip_relocation, catalina:       "bac131416b355b73eb0675fc2b046b8e3658baf207260905c24ba7f7936dd77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d22d641feaa45669d5fd980f4da6cb09fb2cc0ad30de5e613ed93a31ac84a0"
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
