class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.10.1/pandoc-2.10.1.tar.gz"
  sha256 "938a4c9b0a7ed3de886c73af4052913b0ac9e4aa12b435bd2afd09670bd3229a"
  license "GPL-2.0"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "720d055d2bdafbe818f50e186e710f7a8178719b56cfafa1d1948af16df7d7ea" => :catalina
    sha256 "7174b62811cd4d4116bcb5edcfb55793f733e39ad79d8e8914a8b5e2c71f2b78" => :mojave
    sha256 "ef823fe9876a5a6c3fe25db6b8dbca7b372320f7e6f5c5b224a7696acf5c397b" => :high_sierra
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
