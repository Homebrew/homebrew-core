class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.4.tar.gz"
  sha256 "09270abcb9d120a8fa0a7e3a6d69f56f76af769db0d79c1d8b8e1724fd5f186f"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a278a8a96ba756d73647cbb7209ff96d3d81b37417cb6649305807b8d8ff4ad3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4867fdc2e2be2b019bbd481b1949e45ec574e4d7e1adc35d4f7e5be4ef6af6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2a4b850deabaa130514e35a3ab6b6cc4c749b0e85aaa5849a9c1f9439f1aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "2027f9458db2937da98b5925a16d6de65e24429455b98a7ea984439110cdcb0a"
    sha256 cellar: :any_skip_relocation, monterey:       "71179bf729acdf81a55ad2f5bec134e76839aa538b9a88114668c2891dc1b507"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c7e067166a2f8b28cb517e88dc3286d588f59a70d699057cb086a3ef959856e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f0f93c655aaf776b2b79fc5a531c04c1215b014970c188f4f5cb3e644aee29"
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
