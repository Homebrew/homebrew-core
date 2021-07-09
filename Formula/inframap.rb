class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.7.tar.gz"
  sha256 "e9d6daa48c6fa1a8ecc5437c7121cb5072eb81c29c88ca9e6d778637c8442332"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a7bb3f525440891ce100f3d847ca7f06df2c94d6ce3e0c4dc621e72171dd1c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "958f736b7e0c02a142ec51bd43291e9bebca1abcfbd4afce02c74432ee1f838a"
    sha256 cellar: :any_skip_relocation, catalina:      "00f393f750d9ba38730b3ec3a3292b1cf6ddecd54ee113bc8102b74dca6bf655"
    sha256 cellar: :any_skip_relocation, mojave:        "636171542156a61576550bb3bf5d47de02d59a8baef3af71a4a86254837b1bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6bee164aeca5ad224f59777ef59ae1cc0b6a4564ac67b53e905b6cd86dcdda"
  end

  depends_on "go" => :build

  resource "test_resource" do
    url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
    sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cycloidio/inframap/cmd.Version=v#{version}")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/inframap version")
    testpath.install resource("test_resource")
    output = shell_output("#{bin}/inframap generate --tfstate #{testpath}/azure.tfstate")
    assert_match "strict digraph G {", output
    assert_match "\"azurerm_virtual_network.myterraformnetwork\"->\"azurerm_virtual_network.myterraformnetwork2\";",
      output
  end
end
