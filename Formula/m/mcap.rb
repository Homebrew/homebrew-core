class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.34.tar.gz"
  sha256 "6fcefee1eddf062bc15d287fe2e3ab096fd55b52bd1180b4d29f28a1860a83ff"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33cad2f81245a8b30a5a2aa9e158d754349241119ead0a6b00c6e4d704ad16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dcd5487668052248ba4bf99b179936c534213031e21af3868475ffbaa0baed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee31b7fd5ec59d68291dcc258111bfd3393d502faa9386edf6a8fae87ba5123"
    sha256 cellar: :any_skip_relocation, ventura:        "3fa8a8e7427a77c7ed17d013c9c959ffe7dbd7bfd0333763e03ff30c5e7a0271"
    sha256 cellar: :any_skip_relocation, monterey:       "654ebea8e9ec19ab64d700cccd04de4fe496d3b76f815cd2ed8c438ae58435d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e90238dfdafcf0b3bbfbbc54b8c1a22c0f6c53cb313c52a8307592c6bb4ba638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c819bbffa80a36db1a5f569821a66314c1cc52e4d7047ad26c81474b74432160"
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
