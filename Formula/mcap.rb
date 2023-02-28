class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.27.tar.gz"
  sha256 "c3b3e0e4072574e0849b308334cf1b2a8218b79c503976e829d47bdb7a626752"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168ee918c8f4df88faeaadc02c7676cf33345d1c7997eaef5bb3e2ff464f4d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2b96abd842145b21de8df722f14cee12db47a62f0d4ce2662f18823d14cdb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f3c5c39121d44ca0c7b9f58898d00e377bd7b211fcd77df0379645c8b5d012b"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b6d499578eef76f1105f41b5c3d738cc190b94604dbcae8fdb34fcd055a7d4"
    sha256 cellar: :any_skip_relocation, monterey:       "704f78db7e649dc93a617653753ae06e9c3508f4567fee2198f2b1ddce3573f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "065a061826413f2c019f87705b477f4e89cb4a28b94d152cffb0e63c5091d2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab999beb1b5bf090e354c57125efed364209cb303ccc08c513f12a78e5dd3b7d"
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
