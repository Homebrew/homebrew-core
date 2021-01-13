class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.5.0.tar.gz"
  sha256 "614f8e775feb21d13fec04390808faa5000dc2ec0b67f06be2875a8fa949b1c6"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8db89e38e5d255b7bf38c2d375e9b78a8565b78ad7776ed6491a72c8ee6d4e46" => :big_sur
    sha256 "c3cdff1f1acd5706a3716c8af7532c2bcbb49c5d91cc529b006ce77c7c8a52fb" => :arm64_big_sur
    sha256 "bbb1e66bfee4b0a097403c1bc862a85065b6edcb176699758e7508f0d5d9000f" => :catalina
    sha256 "075ef7667e91efaeda845953975e59d46b19cfc1455186169bac1d758b0ecabd" => :mojave
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
