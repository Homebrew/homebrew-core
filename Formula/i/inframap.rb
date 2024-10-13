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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a082886e9254728b9425ecb668c9bb747d55b4b4860029fd5bd58c13125df5eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80770fc43ea2135c2e0d5b570613f6be76f793f27c6fd4a789bbccf0f2a055fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0b7cb30405634f07640eb264e406d472f155719b0b7bb51e6a39728ff5cedd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef9bc0bde009c80f6d1e4c5646936799fccfecaec04077fc91f34ff83f260a41"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3e228ba7ef4a41d01eeafc2818078661487352e305afdecfac6aedc29f4ef31"
    sha256 cellar: :any_skip_relocation, ventura:        "cc2d627e9356b2ee35339a302320873daf4170f7d5fe7d55d5d8c3ada572af2e"
    sha256 cellar: :any_skip_relocation, monterey:       "151e48157fad893e8edc1c353460ebe42713c50f1565c5450e17aea0754f2cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c039f5aa5c65db786cdfe4095b8257999b90b5fdd7321a4e3b83bfc62f1226b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cycloidio/inframap/cmd.Version=v#{version}")
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
