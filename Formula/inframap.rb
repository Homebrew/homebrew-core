class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.5.1.tar.gz"
  sha256 "1384b4a1629d323508ec21905ebfc38b4cca85915c8f5665b27492d4f403ef1d"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27cce7188124c9cff8f36d077d8b8c37275091bc4e0d2baea576cae81a6b09ea" => :big_sur
    sha256 "8464331ddc920853269c71e01e176986c51f713f377b89ce11983a841f0472c5" => :arm64_big_sur
    sha256 "ce5822937679ec9a931cd35c45b14cf02d30bdf2e292ddc77c6d9a830847f230" => :catalina
    sha256 "6d7988dfa381196590d5798aa338f04550a5dcba757221bf76b125915fd77a43" => :mojave
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
