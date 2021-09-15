class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.31.0.tar.gz"
  sha256 "4c4ea4b65bd096a444a56a6b314950a5977879fcae329ad1654db0f765cf402b"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3c5649d4f4e3f03b14205a45299b73b1384b9c4dc9f2e4efdd350f5513aa8e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d98583d24a4880dbf053009a10a6e488a7807d42b08530ffcbd74ebb49d3bc9a"
    sha256 cellar: :any_skip_relocation, catalina:      "b0c6175853456c60daee2cc32a5154ecbc0ae096d6be5da36387eef1e19a3db7"
    sha256 cellar: :any_skip_relocation, mojave:        "aacdcf8502f1a1d00f02dc4dabbf6b2099bfe1bea944987326b36279e906fddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc1a2e1a280035116f6b7a31c67c902feb213b6bd84f8332c5f2bfc79ffe4611"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
