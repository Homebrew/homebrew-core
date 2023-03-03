class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.28.tar.gz"
  sha256 "1717610ed537917c2b06eda70a0cb9b096c1295110d0c350a1aca3377eba4978"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1668238f2890a2a2b9d918cffbca9574455d23070d6e48070f1c5290a08ed15c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90ca4f9c228b0349cdd24c6a84deb1c0e23339de9458130a9fed28e1e62eaf9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e76e8381e9366bb509df8da41ada9ff413237a49dbaa15e522bc8935cbf26048"
    sha256 cellar: :any_skip_relocation, ventura:        "a8fbd4b6f8fe0524b9f277040557059f30788239b05f39be79b8d8f7661d385a"
    sha256 cellar: :any_skip_relocation, monterey:       "33ee488bfe55d961e49b8a7e00de05ebb4066aa5f73e36fec84320851c4e0535"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ffd85068f55b2168487013af31035bb736298c8158cd65e5161993f8412b8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53266a63c360cc2bc597ed7f370db2ca660457974a59fae2fe3f4de43bb5ee3e"
  end

  depends_on "go" => :build

  resource "homebrew-testdata-OneMessage" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
  end

  resource "homebrew-testdata-OneAttachment" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
    sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
  end

  resource "homebrew-testdata-OneMetadata" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
    sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end
