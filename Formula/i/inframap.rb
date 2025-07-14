class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "1dd1080245198eb53451502b40994a90e97eb283dc61b0d77d620f0ee6c1d23b"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045720e46c73c4a8f8398d48d0a66207e62195d8797c7f69a8ac1ab1a3bf7412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045720e46c73c4a8f8398d48d0a66207e62195d8797c7f69a8ac1ab1a3bf7412"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "045720e46c73c4a8f8398d48d0a66207e62195d8797c7f69a8ac1ab1a3bf7412"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa596b7fd67f707f8a838582b00f65c4a195c1051654a2f72c4e78d0f0d968a0"
    sha256 cellar: :any_skip_relocation, ventura:       "aa596b7fd67f707f8a838582b00f65c4a195c1051654a2f72c4e78d0f0d968a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6621e3619bcb502a7e99fbf8043fac869cf1d03b6fffb09945bf759d721093b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cycloidio/inframap/cmd.Version=v#{version}")

    generate_completions_from_executable(bin/"inframap", "completion")
  end

  test do
    resource "homebrew-test_resource" do
      url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
      sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
    end

    assert_match "v#{version}", shell_output("#{bin}/inframap version")
    testpath.install resource("homebrew-test_resource")
    output = shell_output("#{bin}/inframap generate --tfstate #{testpath}/azure.tfstate")
    assert_match "strict digraph G {", output
    assert_match "\"azurerm_virtual_network.myterraformnetwork\"->\"azurerm_virtual_network.myterraformnetwork2\";",
      output
  end
end
