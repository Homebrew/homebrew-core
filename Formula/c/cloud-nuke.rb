class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "4f5ded36a48c58002251871c5fe639e6e241752d2dd7f7c4cc18f63c24b3f0f5"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed48e67ea53dc11ed3f4c8f4b845c7fd6c6ed6ab7e7b1d079870d5960c44c58a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed48e67ea53dc11ed3f4c8f4b845c7fd6c6ed6ab7e7b1d079870d5960c44c58a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed48e67ea53dc11ed3f4c8f4b845c7fd6c6ed6ab7e7b1d079870d5960c44c58a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceda6f48d619e26be92576c031628e4dcee2a1388de7ba7fdef820016a7a07ed"
    sha256 cellar: :any_skip_relocation, ventura:       "ceda6f48d619e26be92576c031628e4dcee2a1388de7ba7fdef820016a7a07ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d71a6c40a5df3f64e5bb4fbd18abfb6a2020472971f277591d7ab74769003b"
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
