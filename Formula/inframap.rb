class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.5.2.tar.gz"
  sha256 "0d549133f38d010a03dc2aacc4b8323eed8ae4f0832a257d649086eadd14fab2"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34da1d1127494fe8a0b57f2ab6bda70d7084689a0bb753a53198a4e8990c2ac9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1edd54bc8e875a86d5fef988d7ba847f742ef5cf87474be01526966245be1ce8"
    sha256 cellar: :any_skip_relocation, catalina:      "948c1b6db8e48a400455aa75a9ec14cbf0a1e0cc50d37788324192d585f9bfa9"
    sha256 cellar: :any_skip_relocation, mojave:        "2ecba3ee89e406982c314a9789d5010a44255413f66e6717b96bd0d52420ee81"
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
