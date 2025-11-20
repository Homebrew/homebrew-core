class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.57.tar.gz"
  sha256 "00bfa671eeb44a3abdfb543cdb6faa7d13900fb8f174497c1f6bf3416e4023af"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67995c19bf4c473bd47d80fd3ead323d7402aa19c8c93ff937a0fbd80afecc80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8e1e76a8c1a882211e44939afbe65dd0ac5f75e94ff3429f0a25e45fe34a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a35abe9446eee43836d8b356057fba0d149b3da2f5037cd5e288ac22d1efaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de0ed279e744a584159814de426b8f996bb44703504dac87cbe24bd25fdcf32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bfa8f864c8379536b69f96ce913670f209ee38f5697ae7c0dbc32a2cfe5f7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f196c710b6f26efc0c0ee0cf5e4d6d7cc7a17dbccdba039352d33fe51b7b3f54"
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
