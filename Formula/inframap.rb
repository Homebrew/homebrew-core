class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.3.tar.gz"
  sha256 "b599f1f8278c9c6bb9d6c8024659dddd36875592445a23de5a047ef92015b4b2"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bdceafea8ec6a321512dc5a58ac83283f5421bd32e10c41fb419f882916625f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e7cb2d33cec50d151ea8424a49993d92432984babcff88793de7ca80fcbadfe"
    sha256 cellar: :any_skip_relocation, catalina:      "4cbfd3e69a9b85bb3d15c0d5844003e67644d99efdbcb7b74ac5b67f414d6fe4"
    sha256 cellar: :any_skip_relocation, mojave:        "3e7f66cbeaff89411eda9e630ba72d6b35e93bdc5b7c3ad6f1718ef562a7ac9e"
  end

  depends_on "go" => :build

  resource "test_resource" do
    url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
    sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
  end

  def install
    ldflags = "-X github.com/cycloidio/inframap/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
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
