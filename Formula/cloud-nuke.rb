class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.8.2.tar.gz"
  sha256 "a00447bc8ff651c2ef26e73cfa397e8ecde2677023951451be786c62640bbdbf"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd92c272b7fe37ca7a89fbe4b6f7ce455b5be3c96f584491b361b5d3d9650cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03573341243e0eac53b94c05880b69bc6626c0f15c880f393f51eb6e975f584d"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc5c3cfcc2aa3674260c00dbe90f3ec296ee7f163affa4a10b0d33ee3442c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ded5b96eeab5f397b1324fef580a7fc4ee664379ec9d1ce360cd119a4ba4116"
    sha256 cellar: :any_skip_relocation, catalina:       "3978bfe94133c56380c6ca27e0367ff1e27aa36c85ec632ab84ed583fa74ac02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270be9b7aed1f1d0b690f70d0b0e703056b3acf490b923b28624533e8a519a68"
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
