class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8a8737f674105745ac91b430fad2e7c40e35bea289c7c391affae1d4490aa56a"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1ac865acbd8ff00c59103b7d798f4a6c9cd2d3e043bc10cd36db0e3a03ec911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b85ed63be91cb09cf0f5b38a83a713f793872ba852a6a2fe7da0c841db539a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e3fed00e165ff0e68367a443a5b585ffb0ef0d2bea4295a89a1120a196b74fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dec3018726053b46aa1f82bbb25572dec49662d5f8c0b3701a71ecdbf7f94bc"
    sha256 cellar: :any_skip_relocation, ventura:       "8e182e1c783cf56a357194806f3e06a0f1b52118ca6b30267e45c3e208580818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d23215052fbdbcc93ce12d17df2df06347bd728c890226a68c12b906e029ad63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
