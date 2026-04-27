class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "c846977a1b445737e199b1565f09f17f4d9f53d4ef585fd39627b149f17e3a8a"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae31ec0395129162af3fedc9c3adb493f972383c7dac5ae7178e2011a6e05911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae31ec0395129162af3fedc9c3adb493f972383c7dac5ae7178e2011a6e05911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae31ec0395129162af3fedc9c3adb493f972383c7dac5ae7178e2011a6e05911"
    sha256 cellar: :any_skip_relocation, sonoma:        "054b764bacd6b64cb5be9f36e6aa476960ac460b06a855931cd6e0c84df7b4b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53149571561b0510d710bd714d0cf079523707b114857e9035b635067151741f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a3d670fbb4a76b880ebb96533df86e6fce39494e85be60e7ce13f778a7c7ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cycloidio/inframap/cmd.Version=v#{version}")

    generate_completions_from_executable(bin/"inframap", shell_parameter_format: :cobra)
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
