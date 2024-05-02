class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.44.tar.gz"
  sha256 "bb866e9c38656244831f4e569bd31c572a144e4cab9dbc247f19fff6f10a8b73"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90542d3f966b55908a31b70aa85469300e2e733311c2a766606ff7d312ed8945"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd831d471e355763f97484ba754ee9358c7c67bbc88f1c7ee26ce2830641ec5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9117457868fcdf67d6a0f951a690007875c81d4e34f0fa02b71d5d9710849abc"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa73788e6808a5b7abce0b2d84762ac5ba50ea922e9aace723ccfb4eddf5c3fc"
    sha256 cellar: :any_skip_relocation, ventura:        "841a0cf4b8e91d08d66db788582fc20f88fd34c9ed97b531458b99ccc9db04e5"
    sha256 cellar: :any_skip_relocation, monterey:       "df0a98a6be93ada04c0d414cd911dd2d192a540672da6f044d4f089928994843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3478e1f798fe8bd6d24b7308f414a1928c7ae9e725db79419fcf24d7a9a5080d"
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
