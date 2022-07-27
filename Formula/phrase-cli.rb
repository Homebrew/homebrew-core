class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/cli"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.0.tar.gz"
  sha256 "0705b479b4e546515c3c7ccd45aeb629f3a43f8dc18038c3c33ed792aa06614f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fcb40e8faa86f3e686b0598b8fe0e9304a480eb152d812d1320365fe8ee3b97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "096c75f210dcc8c097ca89377cf01a364035695290b1988ac9ca10ffe88129fb"
    sha256 cellar: :any_skip_relocation, monterey:       "82324ca1225778d75328f6f06ff65c2218e3c447f4ada4eaeaa12cde9d34fa62"
    sha256 cellar: :any_skip_relocation, big_sur:        "29e960fc9e1d974ce80de9adbdd8713d4ed55f19350629a4bc9ea0025fafbd78"
    sha256 cellar: :any_skip_relocation, catalina:       "fe7550a4af2d2dcef2b8eadd5ec77529b8504b52c649b1b6323c1be31bd35955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ae1d093038c152d31272f0fb4d494b681bc2062394325d8c723e7a20df9bcf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
