class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14.0.1/pandoc-2.14.0.1.tar.gz"
  sha256 "23afd822ee0416c8e8a3179dde698e7753724325b5a21a26f9c9591c5aabd03b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e88f643a220c50d8c945fc14c1376b2b826f7f365d5d72ca2bb6853ea3542774"
    sha256 cellar: :any_skip_relocation, big_sur:       "64957c379283e5eacec5c8263acc0e1566c53d34c222e2e48f990eed14305ca2"
    sha256 cellar: :any_skip_relocation, catalina:      "2d9190289fc774dea06b4e34d819c6fac08dbe494ff0f18aa47d80c361251df0"
    sha256 cellar: :any_skip_relocation, mojave:        "df61dd06cec82dcafe120d13936d736b8ade839ae26f43d6d998887670741892"
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
