class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.3.0.tar.gz"
  sha256 "9a6dbbd938dbd3bdd4c1bc9fb5541b43c644c6e238c9143c256fc54d45e964c0"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0b6c8ce8fea0d56e96c8536b79ee01f46ac9f5e3311d96cdf5e9efee59112e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848830bf79df06bccebad1810d1430a5136b1dd2eb3db52294573c92fae4ec7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897ddc0b46acd24061961ee3d3ece4dccd2b3367e00cccc1724ef527001d5e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb05daa81ec10a19bed7d563ef61a73a3cf05c10ef1d48dfe530727e01f3b800"
    sha256 cellar: :any,                 arm64_linux:   "ed87fd8673d0d4ce72aceef6848f708fe6bc3c7276b1ae7013c291506eb3bda3"
    sha256 cellar: :any,                 x86_64_linux:  "38dd65f00c7325d49abb8dbefdf2adfe33964ef0f4b581873b6a618e28c9c77e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/cli")
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

    # Revision in parens must be a git short SHA, not "unknown" (also 7 chars, hence the hex check)
    assert_match(%r{^mcap #{version} \([0-9a-f]{7,40}\) mcap-rust/}, shell_output("#{bin}/mcap --version").strip)

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
