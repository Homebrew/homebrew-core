class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14.0.1/pandoc-2.14.0.1.tar.gz"
  sha256 "23afd822ee0416c8e8a3179dde698e7753724325b5a21a26f9c9591c5aabd03b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "bf26d6505074279f2213266d41deb2ec43bcc759f4c8d2ede44bcd47775ffd62"
    sha256 cellar: :any_skip_relocation, catalina: "6bf648b2067e3bc446fd1306de3778e7e5a25f2e7b7c089a9e40fa8ee9501c77"
    sha256 cellar: :any_skip_relocation, mojave:   "fb8f80c1ff5cff3386e7bdf785fe60cbf2fb87b780e73624e38bc4e3aac23d5a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
