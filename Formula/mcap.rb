class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.31.tar.gz"
  sha256 "01b1efaec6f433e65193e43e92bf12ca4641e8729432c3766087c395b4a2a601"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec4558c06f936a7bf4ebf306db7ff07f242c29d589d4c45ff57c5ff201b74bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a90112958d8ec1da4ce6079f31aaa32e6201f7103d03ce9c8e06950ffdadac1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4656b0b0030195ce569a84bf510876d23ad8a1b7f705eb95c28c07ec47a9f3ca"
    sha256 cellar: :any_skip_relocation, ventura:        "12d96c479974690ff43cd2ecc1948c0c3f394b2ed467a25bd2ad396461d84262"
    sha256 cellar: :any_skip_relocation, monterey:       "94fd58999ec2a36480a1f95a67f2b715b0799d41a004795cb71b74ddfafc1841"
    sha256 cellar: :any_skip_relocation, big_sur:        "68da206d3c996198769ea975b1baa44239d4234556c9c1b34adc91e8ce63a804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527a88a4bd9c416746b47b10eb6d805e5080c5f3d9b8b1a5363fb2760e4ff6dc"
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
