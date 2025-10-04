class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.55.tar.gz"
  sha256 "c46e024049847be6a55322ac502c9c453e19dd29dfe90a089a5154d0c640226e"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4247a64fdbdebcd563d02014b63226206aef809983bdbfa9950beedf0e359971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed15b94bc233ade2ca966431b0913fe927937402f074469ab6c58312ccd74916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5c69274074a3205d9aa427f63cc2e1ee75deb670366f485636fed78397a853f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd125bf17442e5c2b10a47c6e495e4fe8e6fa2911d1fc351dc7f9e13f90affe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7454e3a2cd9eced4ec58790873530a4daddf4af00ca69a82c25185e34a20d47e"
    sha256 cellar: :any_skip_relocation, ventura:       "8c3ba6382be81e5414660cb61c1905d5346ee78002c304c6e1455d48788a3cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c3e1ff564af8d8c7a8f0f3f560b8b1879dbbfb5d56d959ff859919b95cc395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368bdf86f510da20bf84a128b7fd2d2664e27890863d5ca89679caab6c3182a2"
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
