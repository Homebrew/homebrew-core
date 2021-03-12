class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.1.tar.gz"
  sha256 "4424f400b4cd9b18bd499e865640ef6626e1cf89c7465af2d6626551cb2bf192"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "624dbe6146c65c8c736a81f3c0beff375b6dbdb5acb99ccb6ee036e42192dbab"
    sha256 cellar: :any_skip_relocation, big_sur:       "176bf36699a35ecb998ff7fe944f053dc29b3847e230954a55991b5de55d1975"
    sha256 cellar: :any_skip_relocation, catalina:      "c3c4b891931578b2e018d9798e668d19a7ffe6a54785a4c2971abe7e37f6e5c3"
    sha256 cellar: :any_skip_relocation, mojave:        "e25f036729cab0024327b2004da922d2b102ece21e2724e40df08698f84aae9c"
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
