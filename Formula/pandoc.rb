require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.2.1/pandoc-2.9.2.1.tar.gz"
  sha256 "c26d35372cf8b7d53062c9c495c0bca2ee370891c2349d3798a44f9ca33bdf57"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "040eafbe1ebb8fe4c2b27425d7d3e566770c8c531eee7fdec2c96e01f4bf32a4" => :catalina
    sha256 "61493929e5168952bc5bc64149bf67f8bec818313950aee764273b146b126442" => :mojave
    sha256 "0fa6bfa3d880c8dcc41a469bd60ae74202094fb16bf6ca7ed48bf1cba11aea0b" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    cabal_sandbox do
      install_cabal_package :flags => ["embed_data_files"]
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
