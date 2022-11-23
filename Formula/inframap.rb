class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.7.tar.gz"
  sha256 "e9d6daa48c6fa1a8ecc5437c7121cb5072eb81c29c88ca9e6d778637c8442332"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8346b10cb9a2054a86aaefba38ffa80f36bb2696b987aca77ab9e2c7e68dca3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "763af27a8d3dbb2ccb3c7bcb63d337ee96e7f5c011dcecbee7768d76214814e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee096fc9fe0909cc34675dbd7a7269c8092ffee0d6ba71fa333e75afc4ff28c1"
    sha256 cellar: :any_skip_relocation, ventura:        "41de7c7b91cc5ccf46b5d4de5fc59e9ca9d941a4dd060fab01c3db3b7e62b80d"
    sha256 cellar: :any_skip_relocation, monterey:       "36b5b88b60390bc015fb56166cb7b890c8e5eb2f736a30384dc3fa92cda9f351"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4fe8ae6b7fcf419ab21ea31beb6b90dbeedd73ba2a771672e41c7a30ff4d0d"
    sha256 cellar: :any_skip_relocation, catalina:       "ba85244090ace0d6a94dbb41c9693f11647cb8e949acc5511c8d9c25a3f74c1b"
    sha256 cellar: :any_skip_relocation, mojave:         "d7bb58c695d390162b9a5376decf76acf02929d9b4421137ccbb7e91f940bdd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d90d38dfbdddf34bdeea89493f6c76874392166e777d42f6d477690cb880c6"
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
