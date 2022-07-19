class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.14.0.tar.gz"
  sha256 "614f8813d3235cfa083f4cea26e566633e1a624f02fb6abd92cd4640e440e95f"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653db1ebf8595a1be7b83e7e7fbf507f6c29f57f73d3f4f92dcfa109abdc06ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e0e347dfc776f28eb19657d3f11cb90be1311efdca48da2b0d42cd24c1e434"
    sha256 cellar: :any_skip_relocation, monterey:       "94d59e3c799271586569b0e17dba47354475a9680c66b7ab9d533ed5d96147f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d85eb6be99897f159530d9bfb4b95733887cd09c1cf7966fcff09b4f69695a"
    sha256 cellar: :any_skip_relocation, catalina:       "c3a10e04cc354c8cc342d999aa7c4b010f1fdd5015f46720942fd96953986bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ded0af8314af693d42333256241b7273777d7d033cd50d917014430e35f0556e"
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
