class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.53.tar.gz"
  sha256 "1dea3f72747de3fc5b254008551468d30c0405ebf13a7e3d27d02e50c2a13e0a"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e37b7daf00b078c7f33852753ca7f3b05feba296a498d5b961e4ebd592b9d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e495570b9381ec70f69f49e6e2d39e2bcd719a1681402bd0c8c26620e60c86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5fbda70d150a1356a7d6d7e56d2d3fd5cce9a30ff8cb01df60f50733deef198"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27b20a0976af88458f35d143917d388d7b45896e331caf3268d3923824356fe"
    sha256 cellar: :any_skip_relocation, ventura:       "75e8f9c45a0e94345fc3193e62c214df180207e7627337c77a3da3c6c22f5876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7178a980cb38092fa21b86e638d8e98a58c347f9ca7f10435afc1cd7bd284826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff77b759aba4f8888cc8f9f71f68c2f9d1555d5c679e48c9afaadf9a6cf0db1"
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
