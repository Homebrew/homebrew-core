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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fead9853b4b1b9f4bca0b20656c6c5ff98555a0590e04beb1120ab95b4752635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e6aacb8e602b2c4fd488a1071209c1711ba388fda1f19797665915b6e84c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e6aacb8e602b2c4fd488a1071209c1711ba388fda1f19797665915b6e84c36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e6aacb8e602b2c4fd488a1071209c1711ba388fda1f19797665915b6e84c36"
    sha256 cellar: :any_skip_relocation, sonoma:        "95af43179d426a7a6dd382dea950559c3bc479bc00cf7b9bf4865a854a44b57d"
    sha256 cellar: :any_skip_relocation, ventura:       "95af43179d426a7a6dd382dea950559c3bc479bc00cf7b9bf4865a854a44b57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "803d93620c47d794eb3b6336c1c0059725a941382b8c546c3f00ceb02ecdb3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf01e9146e3abf82239ed0e2f498916a5eb8ff863099e70c840393adf8423dbf"
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
