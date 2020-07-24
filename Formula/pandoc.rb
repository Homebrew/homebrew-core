class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.10.1/pandoc-2.10.1.tar.gz"
  sha256 "938a4c9b0a7ed3de886c73af4052913b0ac9e4aa12b435bd2afd09670bd3229a"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01d0e8db1abba83f3d15037b086366540f056e570f26a0d24c682fc050ee0792" => :catalina
    sha256 "4f7a07818eca3a4efcbcc952ea23f50236f0354c821a145a7324aebee890eb01" => :mojave
    sha256 "38286fccde0f3d8afa8aa59b8a6365837581c1e83074c13bb98ed66b14a6d79e" => :high_sierra
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
