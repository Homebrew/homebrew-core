class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.61.tar.gz"
  sha256 "8bc715a6a667cdd0d9ce7d474436ca19a9be06d1350ddf026f43cc499c203886"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5285d5c2295682d3fe70506004115e76ee695a4a1a6f7a48b4fb08080eb7bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3313c1c9d3ab7168084813e3b2f72095a6727c8e0b7106df8b83cdcbf623b3e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d6abf93d29a22f0a753b6912416c8f3eef4bfb2eee8a2b6d5afee62ed8d9ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e074b0de17ef809ec07fe19f765f85ba51805d34fd7612add347ff17265ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d00e8a12ebe7a922495bb3ed892bc27f40b1784f20aceef441b2a67b4c003c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a09c30d2a63b3914170287fc55d5d293a089c4bf46d20172f98859d8a20f5fc"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", shell_parameter_format: :cobra)
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
