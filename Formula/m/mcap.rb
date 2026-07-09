class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.2.0.tar.gz"
  sha256 "6969ccf8e85436eb786b5f5e25a6a30cb52d42d5f2672883f8dbbb93bffa9b5c"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b2d74f50c4d3c86690a205d2a22420ced9784cfeea64b67872f9f618a832a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd347c9103354a86933ac80873f83284bf96ed46ffa5920e77f3eda553f9e9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117aafa770f4f7f7d33d8ecbc51adce021c0d614feae2a262fe7588514151472"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab1bc09f31c8f13f9de8b0ae35f5018e34835cd2834fd0789376abfbeb36795"
    sha256 cellar: :any,                 arm64_linux:   "aa17cc5bc5cb7c74730f1543b34a2a5549b26fb9ca6db43b0695ddc26345c1ea"
    sha256 cellar: :any,                 x86_64_linux:  "74577b9ce6ba2d42c44559d609c6cf035edca7ba2af3ce4d6572d994e9f819f1"
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
