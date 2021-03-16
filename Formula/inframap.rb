class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.1.tar.gz"
  sha256 "4424f400b4cd9b18bd499e865640ef6626e1cf89c7465af2d6626551cb2bf192"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef68bead60c689f98fcb8c069f1ecf77b18c3290013506a12f9af341f38e4b99"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bf02cb13a32fda783f0ff53e8c405792ba70f563bfef32e56b6b34847f73ee3"
    sha256 cellar: :any_skip_relocation, catalina:      "256e4392c2d4d61912271926425d46fc7dc04578500a42cf715d810c02d91448"
    sha256 cellar: :any_skip_relocation, mojave:        "7f6af2c6121c70104b8975c49a8c579e128186e899a1e83ec3b2ff5e55185bd4"
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
