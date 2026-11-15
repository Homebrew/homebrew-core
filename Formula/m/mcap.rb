class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.4.0.tar.gz"
  sha256 "f3f91a632195ca996829717d0cad480db14376e7c8534d9ac0d03d58d24299aa"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f01a518987c86391e3f41a76e1ad4154c8f03523c4c67ebf35645fb38e841284"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f739ebb4d57ed60dd2af88b2343abeda2586bbd71c1a0bae4932b884abba5d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9019117708d0a89d19d0aa697c5b5fc525c25f02f3ab943f1ff0b4a7f114592b"
    sha256 cellar: :any,                 arm64_linux:       "374f5cd6e90aeadaa148bfc15b61e7faf194f987fa90fae2a80c2be7c11ef27b"
    sha256 cellar: :any,                 x86_64_linux:      "17b261ff14d53937505e13c670f9df4b09a43e591abb1d2938e54b9c058cc12b"
  end

  depends_on "rust" => :build

  resource "homebrew-testdata-OneMessage", :test do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
  end

  resource "homebrew-testdata-OneAttachment", :test do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
    sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
  end

  resource "homebrew-testdata-OneMetadata", :test do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
    sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/cli")
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
    # Revision in parens must be a git short SHA, not "unknown" (also 7 chars, hence the hex check)
    assert_match(%r{^mcap #{version} \([0-9a-f]{7,40}\) mcap-rust/}, shell_output("#{bin}/mcap --version").strip)

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat --time-format=nanoseconds OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
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
