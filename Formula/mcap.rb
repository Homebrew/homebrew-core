class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.24.tar.gz"
  sha256 "54dee25b2484e105ca6b0469a3022887de13183b1fb0b68bba3ff23ed42c56b0"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "453ebc06710a8ec3b504e5d172bbecd71b62711dbd96a8341e24c12b41ac9ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bbf6d685d0383825bbdde3dbd10c523accc3426dc5aeabff32a7db2d28b8e04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539ec7431b20b7861feb4c13cf0409c0271a3d2c5009742d92c3af3d9c58b58b"
    sha256 cellar: :any_skip_relocation, ventura:        "23238babbfe839613a618fad86f905e0d62948cdfd852e08c21739d9d59bdd5e"
    sha256 cellar: :any_skip_relocation, monterey:       "8e70b47759ce389315d34ae0a268b7f0d881ed2152799c1e0aeb988bde8aab18"
    sha256 cellar: :any_skip_relocation, big_sur:        "454fb86d73c9341379432d029119697a8afec7f984da65be309cf6d9a522f83d"
    sha256 cellar: :any_skip_relocation, catalina:       "5d5e7742f0e7bfe5af37a8d6efef9f6b224076cb38a6084bb41e8fc93afcd28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087123a22fc58f38396613a4a24c4b65ef872561555b8282e0633b41dc3dc013"
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
