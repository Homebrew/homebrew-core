class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.47.tar.gz"
  sha256 "d02fa12d0179cf1601c47cab8beb38c4920b1f6f6cef1d0958b1e08cd710c0d0"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ba404146515882a26de3205c3317aaf139bbbc18c1302d5b197afd2c836af8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "999217e45aa391ad0bedb2ba806dabe43aa9c1e82fa2344b038e9d00060f349f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e07014ef69a402c11f4890f41d27026e0c67f2c8a220943c015b958fe7bd41"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cab7ebb1621053644502bdbe7fd921017a605948e1e56a6fac11a6f7148da6b"
    sha256 cellar: :any_skip_relocation, ventura:        "7bcc8b03bac6ad230818cc8fcfa2527626561efc18f43e43131e61dbce472176"
    sha256 cellar: :any_skip_relocation, monterey:       "cd7e22cb634076fa259991e7bf5b65249f5cbc81c4afa1a59cefbe594daed723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2c2740ccaa0369306743eb84c6f0c2b1d531e78345712969bb602315851249"
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
