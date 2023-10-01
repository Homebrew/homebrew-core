class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.35.tar.gz"
  sha256 "cb1c9f0f6a36348259b979cb2f66b785273843e223a463b3ec082696b86e66ad"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f9ef5041ee60689bd90ad4df2f48b574b7bad556c0afb5b5023f8a4fcf8eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad6b9c7b5c70a1f1f8b1cb278b8ca9351bcc90e4cfe0288fbafd471fc3d8cf6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9240246e81fba3b31341f47d588473208b25fad0050ff2152c803e2d5f87f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "0576eebbff22f92ea83ce45a1846a31b9f98aabad99b6b0e8a97fa4a38904ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "971887cd733f1c1255711fe706103cd47e67797f8fad62aad832c591c9fb144c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c335e7322d6f30f6e80dd8949fbf4f83527e2be850dca57e4a19b87d1f206350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761a334dae68c3ed1ed8704c985ffc9bf940b796a4385bdc6dad1b4d8b480031"
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
