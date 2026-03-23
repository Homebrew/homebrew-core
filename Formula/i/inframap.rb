class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f0e3d2a5f51339549802f8ad1650850ddfe81650ceb72ac9ea86fdd95ab2bfb8"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35238fd6006c1e1292640c56f85a7f36c2794851727b2ea8ea91a28ecd3b5056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35238fd6006c1e1292640c56f85a7f36c2794851727b2ea8ea91a28ecd3b5056"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35238fd6006c1e1292640c56f85a7f36c2794851727b2ea8ea91a28ecd3b5056"
    sha256 cellar: :any_skip_relocation, sonoma:        "869a30f97467cc4df989f532fd8e587e600bbcea1e32b7ae1ecb54ef7f545122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b08303d1e7bf81b263e4c775e3fca3900eb31d1e951667255a3cc5e6dc7ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373101f264996d311db6bf6fdb35db1f53d1f0099ec8964bfd5168cdab64f1da"
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
