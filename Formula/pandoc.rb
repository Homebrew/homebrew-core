require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.10.1/pandoc-2.10.1.tar.gz"
  sha256 "938a4c9b0a7ed3de886c73af4052913b0ac9e4aa12b435bd2afd09670bd3229a"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ce29d83ef5cf103c34a3a2339239f9ee1e7f566cd88c218a5cfde0558b237240" => :catalina
    sha256 "10dedb8ffcffce1410ab12998e2c47b251b442e860afbfb9766c1be6b22a94f8" => :mojave
    sha256 "3e39b1ce08f07ac89200da2abef10fc5812a8898ba6daee3e5d6c871ff0d9f6b" => :high_sierra
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
