class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "e7f6e981d20c95a34eb5b858ac554f39003b01f5a50d37980be4bf87e98c7712"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "121415517c2ffae1ebd74d21c8c37f04701104a87a586dc3af5d614ee905e58b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6081054e42b76cb3e6900c7318afe4f406557fe628297d3778700a4a26791d34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7ce8f029a1a8b38c0557af2ce5560b2bbe85f7adda84d38969fdaf704ff9f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3d2332ad2ccb77262bf7897e065c11fe9752430d1be772cd7d934d1dab1a7d1"
    sha256 cellar: :any_skip_relocation, ventura:        "73f1722ffa51ad3ba35fa470aedcf98d06b8e72754e5f149cce72c19fec772cd"
    sha256 cellar: :any_skip_relocation, monterey:       "975b011092d859efe769ae39a103c3ebb4e702f1ef63ceae4970fca724be8c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fe0f1dfa6fd33f5d9f329200d7d3c16ed59cbba465287432cb072ffeebbdf4"
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
