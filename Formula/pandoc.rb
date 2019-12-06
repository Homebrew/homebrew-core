require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.8.1/pandoc-2.8.1.tar.gz"
  sha256 "dd10776259926cc3e82eb307eea1cf8e6a4e0578cc8812eb4ee0366b84d2b453"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "0ad37daba22cb7eb8f8c7ea5d2a6c0a9dd4449e41dc25627e6e35d245bfa3589" => :catalina
    sha256 "34f2c6a2b06880dde6f3d251bfca925f80c205909c1d1284b2e36ceabc9d433f" => :mojave
    sha256 "dfb2c37fa7ba156f31b996596ee7ef38f259d73e8fb71246d1c8efc65fc585b8" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package
    end
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
