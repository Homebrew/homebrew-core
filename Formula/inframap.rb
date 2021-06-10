class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.6.tar.gz"
  sha256 "7adb43db2bda4ac8e39e54515c7923ddb3e0266731fe5d6eaef47248afccee95"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1c2d65f241fdd96b8f1ce1313d9b842fe3843beba660020d8ae0e67e449e25b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e222c69e1d6d56dce622611002f4ebb32d36167159b100ec6b701decebe09a00"
    sha256 cellar: :any_skip_relocation, catalina:      "9e1a83033b1d39d0dac35432bdbbaa025e74c056e997c7b2bd753bb595d88c8b"
    sha256 cellar: :any_skip_relocation, mojave:        "0920f4f8dbc51759de6602275194546f811cbaf292d68f8be0ddb0737c136ddf"
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
