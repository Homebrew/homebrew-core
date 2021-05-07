class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.4.tar.gz"
  sha256 "8fcbedb79f0b0b76d4c42d24e78f8b1199f99b8de5d3c9eba3132794f3eb58ba"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80075f243d2551b0c4ca1ee8ef21157b71a979907b92c0dacc112201f28ef35b"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf1a83d1f799748f6b69a36798e7809478930535cf80e7b3858365f5dc50ddaa"
    sha256 cellar: :any_skip_relocation, catalina:      "d7365e1fe3d502bd2498addea61dff681e45963915683963fef7674772d8dd08"
    sha256 cellar: :any_skip_relocation, mojave:        "ff8276a21c1890a3ce7b35aee8400ea2ce42ecfb8d843f495c176572657b46cd"
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
