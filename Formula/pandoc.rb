class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.3.tar.gz"
  sha256 "694bc9a9b820bcfa54eb9c7c9d92e91b6ca6356a924b66b8c3f5a98b7bdcb2f8"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0052272c6896ff1eea8814d3dec5c8b727ac65471a38c67f43162e98c37d8aac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "145af094a4bdb4338c6caff127f402cdb9f3ec2e5d5d4cbd12ccf95d9c68f9ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fee4cdf9511848518707e541f61d3d403a4ee295ecebbbbb342836358459f65"
    sha256 cellar: :any_skip_relocation, ventura:        "99cc87b0455082cca6f0fe3fe44f1952f49069a3b428b3feab9840fe2213c01d"
    sha256 cellar: :any_skip_relocation, monterey:       "eef09815dc5da184485bac5ab68509aad18af3baf7e26a6aebdb0deff7b98176"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee285b60a0dbc4652e2bcfc0bbcd84d40616534bbb9ce6106a8239fd4b49dfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e2ee87729ec02be40e90cdbd21bc2e063d017c0754e3cdda12bcc06c4a1b29"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
