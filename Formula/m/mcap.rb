class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.42.tar.gz"
  sha256 "0d450a9a8202cfb36c092a5485a09e12588a2fe913a53d4d120ded3c11268fa2"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19d9ff4546c189467eae15afb8b40214a32db4174dc66ba48fc30d117d9ec054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "febc21b5c754cb5fae1a45ff04662b9985d2ca50aac6a61537572613c074e532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9969fcab2148eb5593b3e7def9e071457e998fdc09c322d823d15db42cb35dcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "20560f6ed8a428ab9c755374a8cfb20e78f73c8e0edeb3a7ea8067f59243a25a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4c1da58a8a4749b2278387d54f1c808527887ceea54a3fb1b32c6ea25f2c31"
    sha256 cellar: :any_skip_relocation, monterey:       "5564f548c98006074c621324c7b648d4fc5f50c70ee36bbb7d893f3cb2a1be64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55840e8cf4bffcd73e857a2c522029011be5de888430c300a12a055304c2310f"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
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
