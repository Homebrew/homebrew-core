class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "2144e98b2b0fc2543bec596b2c45491ba3dbe0316fd96c1f99a785309a093dc3"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbffb87b04319ddcea9d4c1c6f5365462f4030296f6da8a1f5d79ad23415d6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a36180ed20159691a129f6691be45cc8860c330383d8091e41abc46ba4c0c165"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b2bbfc16539e92fcf12a7f0dc41b7efd4c1c17a6e7e6a35ff156b023c6ac0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e761f111338c2ac98f494b97b3f9aacabd90dfc5bd4f56e1be7f691ac55e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "603c165e36449cebf9cdbb9cf373b5f989f53f294706cab6bbe0b8ee1bb5495a"
    sha256 cellar: :any_skip_relocation, monterey:       "012f6f7a1890e68646f3d3b437517a0c0845a86ed8d922d1428ec4939053dba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25287d3b81d62e4ca78906ab52665b7bb7b6e2fdfb997ec16b3ad4654861c8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output "#{bin}/cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
